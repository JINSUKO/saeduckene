This is the project that is rearrange by me from the team-project   
http://sussaeduck.store/   

# Saeduck e ne, 세상의 모든 덕질   
   
 세상에는 많은 사람들과 그 수만큼 많은 관심사들이 있습니다.  
 
 [Saeduck e ne(a.k.a. 세덕이네)](http://sussaeduck.store/)는 세상의 모든 관심사들을 모을 수 있습니다.   
 세덕이네로 놀러와 다양한 관심사를 나눠보세요!

## 🕒 개발 기간   
* 2023.1 ~ 2023.2
* 개인 프로젝트로 전환 후 기능 수정ing 💭   

## 🛠️ 사용 기술   
* Front   
   * <img src="https://img.shields.io/badge/HTML-E34F26?style=flat-square&logo=html5&logoColor=black">   
   * <img src="https://img.shields.io/badge/CSS-1572B6?style=flat-square&logo=css3&logoColor=black">   
   * <img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=flat-square&logo=JavaScript&logoColor=black">   
   * <img src="https://img.shields.io/badge/-Jsp-344CB7?style=flat-square&logo=Java&logoColor=black"/>   
   * <img src="https://img.shields.io/badge/jQuery-0769AD?style=flat-square&logo=jQuery&logoColor=black">  
   * <img src="https://img.shields.io/badge/Bootstrap-7952B3?style=flat-square&logo=Bootstrap&logoColor=black">

* Back   
   * <img src="https://img.shields.io/badge/Java-E34F26?style=flat-square&logo=Java&logoColor=white"/>   
   * <img src="https://img.shields.io/badge/Spring-6DB33F?style=flat-square&logo=Spring&logoColor=white"/>   
   * <img src="https://img.shields.io/badge/MyBatis-E34F26?style=flat-square&logo=MyBatis&logoColor=white"/>   
   * <img src="https://img.shields.io/badge/Oracle-F80000?style=flat-square&logo=Oracle&logoColor=white"/>(개발)   
   * <img src="https://img.shields.io/badge/MariaDB-003545?style=flat-square&logo=MariaDB&logoColor=white"/>(배포)   
## 구현 기능   
1. 유저(요청 url:/user/**)
   * 로그인, 로그아웃 및 자동 로그인 - 세션과 쿠키로 저장하여 구현.
   * 이메일 인증 및 비밀번호 찾기 - Spring Framework에서 제공하는 Spring Context Support의 JavaMailSender와 MimeMessageHelper API 사용.
   * 회원가입, 회원정보 수정 및 아이디 찾기 - 기본 html form 태그로 파라미터를 받아서 처리, 카카오 주소 API로 사용.
   * 닉네임과 아이디 중복확인 - ajax로 비동기 처리하여 db 접근.   
2. 게시글(요청 url:/board/**)
   * 글 작성 및 글 수정 - 기본 html form 태그와 Text Editor SummerNote API 사용.
3. 상품(요청 url:/product/**)
4. 관리자 전용(요청 url:/admin/**)

## 🗒️ ERD
<p align="center"><img src="https://user-images.githubusercontent.com/99123637/223102649-2ba5a71d-94f2-4216-bc33-daba47e0055f.png" width="70%" height="70%" /></p>   

## 📑 주요 화면 구성   
<p align="center"><img src="https://user-images.githubusercontent.com/99123637/223145101-c2671d09-826a-4e6a-8caf-1f71dcb8fa86.png" width="40%" height="290px"/>&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://user-images.githubusercontent.com/99123637/223150143-7024dd20-84eb-4c28-9565-ebfd0a8a4b63.png" width="40%" height="290px"/></p>   
<p align="center"><img src="https://user-images.githubusercontent.com/99123637/223151072-aab1814e-2e33-477b-bbc5-a7e1b4e6eeab.png" width="40%" height="290px"/>&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://user-images.githubusercontent.com/99123637/223151181-dff631e2-8e6f-42fe-973e-973acd7086ae.png" width="40%" height="290px"/></p>   
<p align="center"><img src="https://user-images.githubusercontent.com/99123637/223152536-5e73dac7-c09e-491a-9178-5219340742b4.png" width="40%" height="290px"/>&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://user-images.githubusercontent.com/99123637/223151330-e83b92ab-8780-4a27-b773-1470bb0c53cd.png" width="40%" height="290px"/></p>   
<p align="center"><img src="https://user-images.githubusercontent.com/99123637/223151737-e5651eaf-eabb-462f-abdf-600625f7c09c.png" width="40%" height="290px"/>&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://user-images.githubusercontent.com/99123637/223151794-a50204ee-3be3-42a7-9a50-cd1c9b72767e.png" width="40%" height="290px"/></p>   
<p align="center"><img src="https://user-images.githubusercontent.com/99123637/223152640-596834b8-b45a-40e5-a0a7-b4c113f3f34f.png" width="40%" height="290px"/>&nbsp;&nbsp;&nbsp;&nbsp;<img src="https://user-images.githubusercontent.com/99123637/223155965-a0a98dbc-b403-4d6f-8232-ce87d2f66dea.png" width="40%" height="290px"/></p>   

<!-- <p align="center"><img src="" width="40%" height="290px"/>&nbsp;&nbsp;&nbsp;&nbsp;<img src="" width="40%" height="290px"/></p> --> 



