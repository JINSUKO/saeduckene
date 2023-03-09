package kr.co.seaduckene.product.command;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

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
	
	public String getKakaoAuthToken(String code) {
		
		log.info(code);
		
		return null;
	}
}
