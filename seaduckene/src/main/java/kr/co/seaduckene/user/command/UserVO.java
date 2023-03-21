package kr.co.seaduckene.user.command;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/*
CREATE TABLE duck_user (
    user_no NUMBER PRIMARY KEY,
    user_id VARCHAR2(100) NOT NULL UNIQUE,
    user_pw VARCHAR2(150) NOT NULL,
    user_nickname VARCHAR2(200) NOT NULL UNIQUE,
    user_name VARCHAR2(100) NOT NULL,
    user_tel VARCHAR2(100) NOT NULL,
    user_session_id VARCHAR2(300),
    user_cookie_expire_date DATE,
    user_email VARCHAR2(500),
    user_profile_path VARCHAR2(500) DEFAULT '프로필 경로',
    user_profile_folder VARCHAR2(500) DEFAULT '프로필 폴더',
    user_profile_file_name VARCHAR2(1000) DEFAULT 'profile.png',
    user_profile_file_real_name VARCHAR2(500) DEFAULT 'profile.png'
    );

CREATE SEQUENCE duck_user_seq
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 10000
    NOCACHE
    NOCYCLE;
*/

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserVO {
	
	private int userNo;
	private String userId;
	private String userPw;
	private String userNickname;
	private String userName;
	private String userTel;
	private String userSessionId;
	private Timestamp userCookieExpireDate;
	private String userEmail;
	private String userProfilePath;
	private String userProfileFolder;
	private String userProfileFileName;
	private String userProfileFileRealName;
	
	private String userKakaoId;
	private String userKakaoAccessToken;
	private Timestamp userKakaoRegDate;

}
