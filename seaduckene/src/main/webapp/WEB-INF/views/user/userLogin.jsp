<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

	<!--Login 디자인 추가-->
    <link href="${pageContext.request.contextPath }/resources/css/userLogin.css" rel="stylesheet">
</head>
<body>
	<%@ include file="../include/header.jsp" %>
	
<section id="userLoginPage">
	<div class="login-wrap">
	  <div class="login-html">
	    <input id="tab-1" type="radio" name="tab" class="sign-in" checked><label for="tab-1" class="tab">로그인</label>
	    <div class="login-form">
		    <form action="<c:url value='/user/userLoginAuth' />" method="post" id="user-login-form">
		      <div class="sign-in-htm">
		        <div class="group login-input-group">
					<input name="userId" type="text" class="btn btn-a" placeholder="아이디" id="userId"> <br>
					<input name="userPw" type="password" class="btn btn-a" placeholder="비밀번호" id="userPw"> <br>
		        </div>
		        <div class="group login-checkbox-group">
		          <input id="check" type="checkbox" class="check">
		          <label for="check"><span class="icon"></span>&nbsp;&nbsp;자동 로그인</label>
				  <input name="autoLoginCheck" value="0" type="hidden" id="autoLoginCheck">
		        </div>
		        <div class="group text-center">
		          <input type="button" class="button sbtn cyan rounded" value="로그인" id="user-login-submit">
		        </div>
		        <div class="group hr text-center">
		          <a href="${KktUrl}"><img src="${pageContext.request.contextPath}/resources/img/kakao_login_medium_narrow.png" /></a>
		        </div>
		        <div class="hr"></div>
		        <div class="foot-lnk">
		          <a href="<c:url value='/user/userJoin'/>">회원가입</a> <br>
		          <a href="<c:url value='/user/userFindAccount' />">아이디 찾기</a> <br>
		          <a href="<c:url value='/user/userFindPw' />">비밀번호 찾기</a>
		        </div>
		      </div>
		    </form>
	    </div>
	  </div>
	</div>
</section>

<%@ include file="../include/footer.jsp" %>
</body>

<script>

	if ('${msg}' === 'loginFail') {
		alert('로그인 아이디 또는 비밀번호가 틀렸습니다.\n다시 입력하세요.');
	} else if('${msg}' === 'kakaoFail') {
		alert('카카오로그인 중에 문제가 발생했습니다.\n다시 입력하거나, 카카오측에 문의하세요.');
	} else if('${msg}' === 'wrongKakaoAccess') {
		alert('카카오아이디로 일반 로그인하실 수 없습니다.\n카카오 로그인으로 접근해주세요.');
	}
	
	$(function() {
		$('#user-login-submit').click(login);
		$('#user-login-form').on('keyup', 'input', keyPressEnter);
				
		
		$('.check').click(function() {
			
			if ($('.check').is(':checked')) {
				$('#autoLoginCheck').val(1);
			} else {
				$('#autoLoginCheck').val(0);				
			}
		});
		
		function keyPressEnter() {
			if (window.event.keyCode == 13) {
				login();
			}
		}
		
		function login() {
			$('#user-login-form').submit();	
		}
	});
			
	
	
	
	
</script>
</html>