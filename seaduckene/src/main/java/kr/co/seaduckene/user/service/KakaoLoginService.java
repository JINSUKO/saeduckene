package kr.co.seaduckene.user.service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.net.ssl.HttpsURLConnection;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Component;

import kr.co.seaduckene.user.command.UserVO;
import lombok.Data;
import lombok.extern.log4j.Log4j;

@Component
@Log4j
@PropertySource("classpath:LoginAPI.properties")
public class KakaoLoginService {

	@Value("${kakao.REST_API_KEY}")
	private String restApiKey;
	@Value("${kakao.REDIRECT_LOGIN_URI}")
	private String redirectLoginUri;
	@Value("${kakao.REDIRECT_LOGOUT_URI}")
	private String redirectLogoutUri;
	@Value("${kakao.CLIENT_SECRET}")
	private String clientSecret;
	
	private static int KAKAO_INCREMENT = 0;
	
	@Autowired
	private IUserService userService;
	
	// kakao login get mapping button
	public Map<String, String> getKakaoAuthUrl() {
		
		StringBuilder sb = new StringBuilder();
		String url;
		
		String state = UUID.randomUUID().toString();
		
		sb.append("https://kauth.kakao.com/oauth/authorize?")
		  .append("response_type=code")
		  .append("&client_id=")
		  .append(restApiKey)
		  .append("&redirect_uri=")
		  .append(redirectLoginUri)
		  .append("&state=")
		  .append(state);
		
		url = sb.toString();
		log.info(url);
		
		Map<String, String> tokenMap = new HashMap<String, String>();
		tokenMap.put("url", url);
		tokenMap.put("state", state);
		
		return tokenMap;
	}
	
	/**
	 * code 받아서 카카오 로그인 토큰 얻기
	 * @param code
	 * @return String
	 */
	public String getKakaoAuthToken(String code) {
		
		log.info(code);
		
		
		URL loginTokenUrl = null;
		try {
			loginTokenUrl = new URL("https://kauth.kakao.com/oauth/token");
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		HttpURLConnection conn = null;
		if (loginTokenUrl != null) {
			try {
				conn = (HttpURLConnection) loginTokenUrl.openConnection();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} 
		log.info(conn);
		BufferedWriter bw = null;
		StringBuilder sbOutput = new StringBuilder();
		
		// start of request POST 
		if (conn != null) {
			
			try {
				conn.setRequestMethod(HttpMethod.POST.toString());
			} catch (ProtocolException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
			conn.setDoOutput(true);
			
			sbOutput.append("grant_type=authorization_code")
			.append("&client_id=")
			.append(restApiKey)
			.append("&redirect_uri=")
			.append(redirectLoginUri)
			.append("&client_secret=")
			.append(clientSecret)
			.append("&code=")
			.append(code);
			
			try {
				bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
				log.info(sbOutput.toString());
				bw.write(sbOutput.toString());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				if (bw != null) {
					try {
						bw.flush();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
			
		}
		// end of request POST 
		
		StringBuilder sbInput = new StringBuilder();
		String strLine = null;
		BufferedReader br = null;
		// start of response POST
		try {
			br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			log.info(br);
			while ((strLine = br.readLine()) != null) {
				sbInput.append(strLine);
			}
			
			if (bw != null) {
				bw.close();
			}
			br.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		// org.json.sinple 라이브러리 사용.
		// SocialTokenDTO 필요없어서 지움.
		JSONObject jsonObjTokens = null;
		String accessToken = null;
		
		try {
			jsonObjTokens = (JSONObject) (new JSONParser().parse(sbInput.toString()));
			accessToken = (String) jsonObjTokens.get("access_token");
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		// jackson 라이브러리 사용.
//		ObjectMapper tokenConverter = new ObjectMapper();
//		
//		SocialTokenDTO tokenDto = null;
//		String accessToken = null;
//		try {
//			tokenDto = tokenConverter.readValue(tokenJson, SocialTokenDTO.class);
//			accessToken = tokenDto.getAccess_token();
//		} catch (JsonProcessingException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
		// end of response POST	
		
		
		log.info(jsonObjTokens);
		log.info(accessToken);
		
		return accessToken;
	}
	
	/**
	 * 카카오 로그인 토큰받아서 계정 정보 얻기
	 * @param accessToken
	 * @return Map<String, String>
	 */
	public Map<String, String> getKakaoUserInfos(String accessToken) {
		
		// start of request POST
		URL userInfosUrl = null;
		try {
			userInfosUrl = new URL("https://kapi.kakao.com/v2/user/me");
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		HttpsURLConnection conn = null;
		try {
			conn = (HttpsURLConnection) userInfosUrl.openConnection();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		if (conn != null) {
			try {
				conn.setRequestMethod(HttpMethod.POST.toString());
			} catch (ProtocolException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			conn.setRequestProperty("Content-type", "application/x-www-form-urlencoded;charset=utf-8");
			conn.setRequestProperty("Authorization", "Bearer " + accessToken);
			conn.setDoOutput(true);
		}
		
		StringBuilder sbInput = new StringBuilder();
		String strLine = null;
		BufferedReader br = null;
		
		try {
			br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			if ((strLine = br.readLine()) != null) {
				sbInput.append(strLine);
			}
			
			br.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		log.info(sbInput.toString());
		
		String JSONKakaoLoginInfos =  sbInput.toString();
		
		JSONObject jsonObjKakaoUser = null;
		long id = 0;
		String nickname = null;
		String profileImage = null;
		String KKLProfilePath = null;
		String KKLProfileFolder = null;
		String KKLProfileImageName = null;
		try {
			jsonObjKakaoUser = (JSONObject) new JSONParser().parse(JSONKakaoLoginInfos);
			id = (Long) jsonObjKakaoUser.get("id");
			nickname = (String) ((JSONObject) jsonObjKakaoUser.get("properties")).get("nickname");
			profileImage = (String) ((JSONObject) jsonObjKakaoUser.get("properties")).get("profile_image");
			log.info("id: " + id);
			log.info("nickname: " + nickname);
			log.info("profileImage: " + profileImage);
			
			String KKLProfileRoot = profileImage.substring(0, profileImage.lastIndexOf("/"));
			KKLProfilePath = KKLProfileRoot.substring(0, KKLProfileRoot.lastIndexOf("/") + 1);
			KKLProfileFolder = KKLProfileRoot.substring(KKLProfileRoot.lastIndexOf("/") + 1, KKLProfileRoot.length());
			KKLProfileImageName = profileImage.substring(profileImage.lastIndexOf("/") + 1);
			
			log.info("KKLProfilePath: " + KKLProfilePath);
			log.info("KKLProfileFolder: " + KKLProfileFolder);
			log.info("KKLProfileImageName: " + KKLProfileImageName);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		// 한글, 숫자, A-z 제외 모두 선택 정규식
		String match = "[^\uAC00-\uD7A30-9a-zA-Z]";
		
		String name = nickname.replaceAll(match, "");
		
		// 이름, 닉네임 허용 글자수 맞추고, 닉네임 중복값 제거되는지 체크
		if (name.length() > 10) {
			name = name.substring(0, 10);
		}
		
		if (nickname.length() > 10) {
			nickname = nickname.substring(0, 10);
		}
		
		if(userService.checkNickname(nickname) == 1) {
			nickname = nickname.replaceAll(match, "") + KAKAO_INCREMENT++;
		}
		
		Map<String, String> kakaoInfosMap = new HashMap<String, String>();
		kakaoInfosMap.put("userId", "kk" + id);
		kakaoInfosMap.put("userPw", "PWkk" + id);
		kakaoInfosMap.put("userName", name);
		kakaoInfosMap.put("userNickname", nickname);
		kakaoInfosMap.put("userTel", "01000000000");
		kakaoInfosMap.put("userProfilePath", KKLProfilePath);
		kakaoInfosMap.put("userProfileFolder", KKLProfileFolder);
		kakaoInfosMap.put("userProfileFileName", KKLProfileImageName);
		kakaoInfosMap.put("KKLId", Long.toString(id));
		
		return kakaoInfosMap;
	}
	
	/**
	 * 카카오 로그아웃 - 안씀
	 * @param UserVO
	 * @return
	 */
	public boolean doKakaoLogout(UserVO userVo) {
		
		URL kakaoUnlinkUrl = null;
		try {
			kakaoUnlinkUrl = new URL("https://kapi.kakao.com/v1/user/unlink");
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		HttpsURLConnection conn2 = null;
		try {
			conn2 = (HttpsURLConnection) kakaoUnlinkUrl.openConnection();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try {
			conn2.setRequestMethod(HttpMethod.POST.toString());
		} catch (ProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		conn2.setRequestProperty("Authorization", "Bearer " + userVo.getUserKakaoAccessToken());
		
		conn2.setDoOutput(true);
		
		URL kakaoLogoutUrl = null;
		try {
			kakaoLogoutUrl = new URL("https://kapi.kakao.com/v1/user/logout");
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		HttpsURLConnection conn1 = null;
		try {
			conn1 = (HttpsURLConnection) kakaoLogoutUrl.openConnection();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try {
			conn1.setRequestMethod(HttpMethod.POST.toString());
		} catch (ProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		conn1.setRequestProperty("Authorization", "Bearer " + userVo.getUserKakaoAccessToken());
		
		conn1.setDoOutput(true);
		
		log.info("KakaoLogout: " + userVo);
			
		return true;
	}
	
	public String getKakaoLogoutUrl() {
		
		StringBuilder sb = new StringBuilder();
		
		sb.append("https://kauth.kakao.com/oauth/logout?client_id=")
		  .append(restApiKey)
		  .append("&logout_redirect_uri=")
		  .append(redirectLogoutUri);
		
		String url = sb.toString();
		
		return url;
	}
	
}


