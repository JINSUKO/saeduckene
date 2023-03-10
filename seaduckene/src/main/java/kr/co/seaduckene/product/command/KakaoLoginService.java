package kr.co.seaduckene.product.command;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.seaduckene.util.SocialTokenDTO;
import lombok.Getter;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Component
@Log4j
@PropertySource("classpath:kakaoLogin.properties")
@Getter
@Setter
public class KakaoLoginService {

	@Value("${REST_API_KEY}")
	private String restApiKey;
	@Value("${REDIRECT_URI}")
	private String redirectUri;
	
	@Value("${CLIENT_SECRET}")
	private String clientSecret;
	
	private String state;
	
	private enum HttpMethod {
		GET,
		POST
	}
	
	// kakao login get mapping button
	public String getKakaoAuthUrl() {
		
		StringBuilder sb = new StringBuilder();
		String url;
		
		state = UUID.randomUUID().toString();
		
		sb.append("https://kauth.kakao.com/oauth/authorize?")
		  .append("response_type=code")
		  .append("&client_id=")
		  .append(restApiKey)
		  .append("&redirect_uri=")
		  .append(redirectUri)
		  .append("&state=")
		  .append(state);
		
		url = sb.toString();
		
		log.info(url);
		return url;
	}
	
	// kakao login to get access_token 
	public String getKakaoAuthToken(String code) {
		
		log.info(code);
		
		// start of request POST 
		StringBuilder sbOutout = new StringBuilder();
		
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
		BufferedReader br = null;
		String oneLine = null;
		StringBuilder sbInput = new StringBuilder();
		
		if (conn != null) {
			
			try {
				conn.setRequestMethod(HttpMethod.POST.toString());
			} catch (ProtocolException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");
			conn.setDoOutput(true);
			
			sbOutout.append("grant_type=authorization_code")
			.append("&client_id=")
			.append(restApiKey)
			.append("&redirect_uri=")
			.append(redirectUri)
			.append("&client_secret=")
			.append(clientSecret)
			.append("&code=")
			.append(code);
			
			try {
				bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
				log.info(sbOutout.toString());
				bw.write(sbOutout.toString());
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
		
		// start of response POST
		try {
			br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			log.info(br);
			while ((oneLine = br.readLine()) != null) {
				sbInput.append(oneLine);
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				br.close();
				bw.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		String tokenJson = sbInput.toString();
		ObjectMapper tokenConverter = new ObjectMapper();
		
		SocialTokenDTO tokenDto = null;
		String accessToken = null;
		try {
			tokenDto = tokenConverter.readValue(tokenJson, SocialTokenDTO.class);
			accessToken = tokenDto.getAccess_token();
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// end of response POST	
		
		
		log.info(tokenJson);
		log.info(accessToken);
		
		return accessToken;
	}
}
