package kr.co.seaduckene.util;

import org.springframework.stereotype.Component;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Component
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class SocialTokenDTO {
	
	private String access_token;
	private String token_type;
	private String refresh_token;
	private String id_token;
	private String expires_in;
	private String scope;
	private String refresh_token_expires_in;
	
}
