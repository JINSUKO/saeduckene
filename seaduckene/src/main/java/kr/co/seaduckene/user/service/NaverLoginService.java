package kr.co.seaduckene.user.service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.math.BigInteger;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Map;

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
import oracle.net.aso.f;

@Log4j
@Component
@PropertySource("classpath:LoginAPI.properties")
public class NaverLoginService {

	@Value("${naver.CLIENT_ID}")
	private String clientId;
	@Value("${naver.REDIRECT_LOGIN_URI}")
	private String redirectUri;
	@Value("${naver.CLIENT_SECRET}")
	private String clientSecret;
	
	@Autowired
	private IUserService userService;
	
	private static int NAVER_INCREMENT = 0;
	
	private String generateState() {
		
	    SecureRandom random = new SecureRandom();
	    
	    return new BigInteger(130, random).toString(32);
	}
	
	public Map<String, String> getNaverAuthUrl() {
		
		String url;
		
		String state = generateState();
		
		StringBuilder sb = new StringBuilder();
		sb.append("https://nid.naver.com/oauth2.0/authorize")
		  .append("?response_type=code")
		  .append("&client_id=")
		  .append(clientId)
		  .append("&state=")
		  .append(state)
		  .append("&redirect_uri=")
		  .append(redirectUri);
		
		url = sb.toString();
		log.info(url);
		
		Map<String, String> tokenMap = new HashMap<String, String>();
		tokenMap.put("url", url);
		tokenMap.put("state", state);
		
		return tokenMap;
		
	}
	
	/**
	 * code, state 받아서 네이버 로그인 토큰 얻기
	 * @param code
	 * @param state
	 * @return Map<String, Object>
	 */
	public Map<String, Object> getNaverAuthToken(String code, String state) {

		String accessToken = null;
		String refreshToken = null;
		String tokenType = null;
		String expiresIn = null;
		String error = null;
		String errorDescription = null;
		
		URL url = null; 
		try {
			url = new URL("https://nid.naver.com/oauth2.0/token");
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		HttpURLConnection conn = null;
		try {
			conn = (HttpURLConnection) url.openConnection();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		// start of request POST 
		if (conn != null) {
			try {
				conn.setRequestMethod(HttpMethod.POST.toString());
			} catch (ProtocolException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			conn.setDoOutput(true);
			
			StringBuilder sbOutput = new StringBuilder();
			BufferedWriter bw = null;
			try {
				bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
				
				sbOutput.append("grant_type=authorization_code")
				.append("&client_id=")
				.append(clientId)
				.append("&client_secret=")
				.append(clientSecret)
				.append("&code=")
				.append(code)
				.append("&state=")
				.append(state);
				
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
			// end of request POST 
						
			// start of response json
			StringBuilder sbInput = new StringBuilder();
			String oneLine = null;
			BufferedReader br = null;
			try {
				br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				
				while ((oneLine = br.readLine()) != null) {
					sbInput.append(oneLine);
				}

			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				if (bw != null) {
					try {
						bw.close();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				if (br != null) {
					try {
						br.close();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
			// end of response json
			
			log.info("jsonNaverUserTokens: " + sbInput.toString());

			JSONObject jsonObjectTokens = null;
			try {
				jsonObjectTokens = (JSONObject) new JSONParser().parse(sbInput.toString());
				
				accessToken = (String) jsonObjectTokens.get("access_token");
				refreshToken = (String) jsonObjectTokens.get("refresh_token");
				tokenType = (String) jsonObjectTokens.get("token_type");
				expiresIn = (String) jsonObjectTokens.get("expires_in");
				error = (String) jsonObjectTokens.get("error");
				errorDescription = (String) jsonObjectTokens.get("error_description");
				
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}
		
		Map<String, Object> naverTokens = new HashMap<String, Object>();
		naverTokens.put("access_token", accessToken);
		naverTokens.put("refresh_token", refreshToken);
		naverTokens.put("token_type", tokenType);
		naverTokens.put("expires_in", expiresIn);
		naverTokens.put("error", error);
		naverTokens.put("error_description", errorDescription);
		
		
		return naverTokens;
	}
	
	/**
	 * 네이버 로그인 토큰받아서 계정 정보 얻기
	 * @param accessToken
	 * @return Map<String, String>
	 */
	public Map<String, String> getNaverUserInfos(String accessToken, String tokenType) {
		
		URL url = null;
		try {
			url = new URL("https://openapi.naver.com/v1/nid/me");
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		HttpURLConnection conn = null;
		try {
			conn = (HttpURLConnection) url.openConnection();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		String NVLId = null;
		String id = null;
		String nickname = null;
		String profileImage = null;
		String email = null;
		String mobile = null;
		String name = null;
		String NLProfilePath = null;
		String NLProfileFolder = null;
		String NLProfileImageName = null;
		if (conn != null) {
			try {
				conn.setRequestMethod(HttpMethod.GET.toString());
			} catch (ProtocolException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			conn.setRequestProperty("Authorization", tokenType + " " + accessToken);
			conn.setRequestProperty("Content-type", "application/x-www-form-urlencoded;charset=utf-8");
			
			BufferedReader br = null;
			String readLine = null;
			StringBuilder sbInput = new StringBuilder();
			try {
				br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				
				while ((readLine = br.readLine()) != null) {
					sbInput.append(readLine);
				}
				
				br.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			String jsonNaverUserInfos = sbInput.toString();
			log.info("jsonNaverUserInfos: " + jsonNaverUserInfos);
			
			try {
				JSONObject naverResultInfos = (JSONObject) new JSONParser().parse(jsonNaverUserInfos);
				JSONObject naverUserInfos = (JSONObject) naverResultInfos.get("response");
				
				NVLId = (String) naverUserInfos.get("id");
				id = (String) naverUserInfos.get("id");
				nickname = (String) naverUserInfos.get("nickname");
				profileImage = (String) naverUserInfos.get("profile_image");
				email = (String) naverUserInfos.get("email");
				mobile = ((String) naverUserInfos.get("mobile")).replaceAll("-", "");
				name = (String) naverUserInfos.get("name");
				
				log.info("id: " + id);
				log.info("nickname: " + nickname);
				log.info("profileImage: " + profileImage);
				log.info("email: " + email);
				log.info("mobile: " + mobile);
				log.info("name: " + name);
				
				int lengthOfNickname = nickname.length();
				int lengthOfNaverIncrement = Integer.toString(NAVER_INCREMENT).length();
				// nickname의 길이를 10 미만으로 줄임.
				if (lengthOfNickname + lengthOfNaverIncrement >= 10) {
					id = nickname.substring(0, 10 - 2 * lengthOfNaverIncrement)
							+ Integer.toString(NAVER_INCREMENT) + id.substring(0, lengthOfNaverIncrement);
					nickname = nickname.substring(0, 10 - lengthOfNaverIncrement);
					
					confirmDupliNickname(nickname);
					
					NAVER_INCREMENT++;
				} else {
					id = nickname + Integer.toString(NAVER_INCREMENT);
					
					confirmDupliNickname(nickname);
					
					NAVER_INCREMENT++;
				}
				
				if (name.length() > 10) {
					name = name.substring(0, 10);
				}
				
				
				String NLProfileRoot = profileImage.substring(0, profileImage.lastIndexOf("/"));
				NLProfilePath = NLProfileRoot.substring(0, NLProfileRoot.lastIndexOf("/") + 1);
				NLProfileFolder = NLProfileRoot.substring(NLProfileRoot.lastIndexOf("/") + 1);
				NLProfileImageName = profileImage.substring(profileImage.lastIndexOf("/") + 1);
				
				log.info("NLProfilePath: " + NLProfilePath);
				log.info("NLProfileFolder: " + NLProfileFolder);
				log.info("NLProfileImageName: " + NLProfileImageName);
				
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}
		
		
		Map<String, String> naverInfosMap = new HashMap<String, String>();
		naverInfosMap.put("userId", id);
		naverInfosMap.put("userPw", "PW" + id);
		naverInfosMap.put("userNickname", nickname);
		naverInfosMap.put("userEmail", email);
		naverInfosMap.put("userTel", mobile);
		naverInfosMap.put("userName", name);
		naverInfosMap.put("userProfilePath", NLProfilePath);
		naverInfosMap.put("userProfileFolder", NLProfileFolder);
		naverInfosMap.put("userProfileFileName", NLProfileImageName);
		
		naverInfosMap.put("NVLId", NVLId);
		
		return naverInfosMap;
	}
	
	public void doNaverLogout(UserVO userVo) {
		
		URL url = null;
		try {
			url = new URL("https://nid.naver.com/oauth2.0/token");
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		HttpURLConnection conn = null;
		try {
			conn = (HttpURLConnection) url.openConnection();
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
			conn.setDoOutput(true);
			
			StringBuilder sbOutput = new StringBuilder();
			BufferedWriter bw = null; 
			try {
				bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
				
				sbOutput.append("grant_type=delete")
						.append("&client_id=")
						.append(clientId)
						.append("&client_secret=")
						.append(clientSecret)
						.append("&access_token=")
						.append(userVo.getUserNaverAccessToken())
						.append("&service_provider=NAVER");
				
				bw.write(sbOutput.toString());
				bw.flush();
				bw.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			StringBuilder sbInput = new StringBuilder();
			BufferedReader br = null;
			String readLine = null;
			try {
				br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				
				while ((readLine = br.readLine()) != null) {
					sbInput.append(readLine);
				}
				
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				if (bw != null) {
					try {
						bw.close();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
				
				if (br != null) {
					try {
						br.close();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			}
			log.info("Delected Token: " + sbInput.toString());
		}
		
	}
	
	private void confirmDupliNickname(String nickname) {
		
		int lengthOfNaverIncrement = Integer.toString(NAVER_INCREMENT).length();
		
		if (userService.checkNickname(nickname) == 1) {
			nickname = nickname.substring(0, nickname.length() - lengthOfNaverIncrement) + Integer.toString(NAVER_INCREMENT);
		}
	}
}
