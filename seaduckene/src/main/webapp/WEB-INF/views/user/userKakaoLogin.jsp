<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
   <!-- 제이쿼리 js -->
   <script type="text/javascript" src="//code.jquery.com/jquery-3.6.0.min.js"></script>
   
   
	<section>
		<form action="<c:url value='/user/userLoginAuth' />" method="post" id="KKLogin">
			<input type="hidden" name="userId" value="${userId}">
			<input type="hidden" name="userPw" value="${userPw}">
			<input type="hidden" name="kakaoLogin" value="kakaoLogin">
			<input type="hidden" name="autoLoginCheck" value="0">
		</form>
	</section>


<script>

	$(function () {
		$('#KKLogin').submit();
	});
	
</script>