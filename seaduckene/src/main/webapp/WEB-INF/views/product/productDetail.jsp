
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<style>
.carousel-item {
	height: 50vh;
}

.cimg {
	min-height: 50vh;
	object-fit: cover;
}

#inputQuantity {
	max-width: 4rem;
}

#board-list-container {
	text-align: center;
	margin-top: 30px;
}

#button-product-list {
	text-align: center;
	margin: 0 auto;
}
</style>

	<%@ include file="../include/header.jsp"%>
	<section class="pt-5">
		<div class="container px-4 px-lg-5 my-5">
			<div class="row gx-4 gx-lg-5 align-items-center">
				<div class="col-md-6">
					<div id="carouselExampleIndicators" class="carousel slide"
						data-bs-ride="true">
						<div class="carousel-indicators">
							<button type="button" data-bs-target="#carouselExampleIndicators"
								data-bs-slide-to="0" class="active" aria-current="true"
								aria-label="Slide 1"></button>
							<button type="button" data-bs-target="#carouselExampleIndicators"
								data-bs-slide-to="1" aria-label="Slide 2"></button>
							<button type="button" data-bs-target="#carouselExampleIndicators"
								data-bs-slide-to="2" aria-label="Slide 3"></button>
						</div>
						<div class="carousel-inner">
							<c:forEach var="img" items="${imgList }" varStatus="status">
								<c:if test="${img.productThumbnail == 1}">
									<div class="carousel-item active">
										<img
											src="<c:url value='/product/display?fileLoca=${img.productImageFolder }&fileName=${img.productImageFileName }' />"
											class="d-block w-100 cimg" alt="..." >
									</div>
								</c:if>
							</c:forEach>
							<c:forEach var="img" items="${imgList }" varStatus="status">
								<c:if test="${img.productThumbnail !=1 }">
									<div class="carousel-item">
										<img
											src="<c:url value='/product/display?fileLoca=${img.productImageFolder }&fileName=${img.productImageFileName }' />"
											class="d-block w-100 cimg" alt="..." >
									</div>
								</c:if>
							</c:forEach>
						</div>
						<button class="carousel-control-prev" type="button"
							data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
							<span class="carousel-control-prev-icon" aria-hidden="true"></span>
							<span class="visually-hidden">Previous</span>
						</button>
						<button class="carousel-control-next" type="button"
							data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
							<span class="carousel-control-next-icon" aria-hidden="true"></span>
							<span class="visually-hidden">Next</span>
						</button>
					</div>

				</div>
				<div class="col-md-6">
					<div class="small mb-1">상품번호: ${vo.productNo }</div>
					<h2 class="display-5 fw-bolder">${vo.productName }</h2>
					<div class="fs-5 mb-5">
						<span class="text-decoration-line-through">&#8361;<fmt:formatNumber value="${vo.productPriceNormal }" pattern="#,###" /></span> &nbsp;
						<span>&#8361;<fmt:formatNumber value="${vo.productPriceSelling }" pattern="#,###" /></span>
					</div>
					<p class="lead">${vo.productDetail}</p>
					<ul class="p-0">
			            <li>재고수량:${vo.productStock}</li>
				        <c:if test="${vo.productStock == 0 }">
				        	<li style="color:red;">품절</li>
				        </c:if>
					</ul>
					<div class="d-flex ">
						<input class="form-control text-center" id="inputQuantity"
							type="number" value="0" min="0" max="${vo.productStock }">
						<button class="btn btn-outline-dark flex-shrink-0" type="button"
							id="cartBtn">
							<i class="bi-cart-fill me-1"></i> Add to cart
						</button>
						<button class="btn btn-outline-dark flex-shrink-0" type="button"
							id="orderBtn">
							 상품주문
						</button>
						<c:if test="${admin != null }">
							<a href="<c:url value="/product/modifyProduct?no=${vo.productNo }"/>">수정</a>
						</c:if>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col align-self-center" id="board-list-container">
					<button class="sbtn cyan small rounded" id="button-product-list" >상품리스트 가기</button>
				</div>
			</div>
		</div>
	</section>

	<%@ include file="../include/footer.jsp"%>

<script>
	$(function() {
		const userNo = '${login.userNo}';
		const pNo = '${vo.productNo}';
		const price = '${vo.productPriceSelling}';
		const pName = '${vo.productName}';
		const bStock = '${vo.productStock}';
		$('#cartBtn').click(function() {
			if(userNo == ''){
				alert('주문은 로그인이 필요한 기능입니다');
				return;
			}
			let ea = $('#inputQuantity').val();
	         console.log(ea);
	         console.log(bStock);
	         if(ea <= 0){
	            alert('0개 이하는 주문이 안됩니다!');
	            $('#inputQuantity').val(0);
	            return;
	         }
	        if(+(ea) > +(bStock)){
	        	 alert('재고수량을 초과해서 담을수 없습니다 재고수량:'+bStock);
	        	 return;
	         }
			$.ajax({
				type : 'post',
				url : '<c:url value="/product/insertBasket"/>',
				data : JSON.stringify({
					"basketProductNo" : pNo,
					"basketProductName" : pName,
					"basketUserNo" : userNo,
					"basketQuantity" : ea,
					"basketPrice" : price
				}),
				dataType : 'text',
				contentType : 'application/json',
				success : function(data) {
					if(data=='fail'){
						alert('이미 장바구니에 들어있습니다. 확인해주세요')
					}
					else if(data=='empty'){
						alert('재고가 없습니다!');
					}
					else{
						alert('장바구니에 등록성공');
					}
					
				},
				error : function() {
					alert('장바구니 추가 실패. 관리자에게 문의하세요');
				}
			}); // 장바구니 등록 비동기 통신 끝

		});//장바구니 추가 끝
		
		$('#orderBtn').click(function() {
			if(userNo == ''){
				alert('주문은 로그인이 필요한 기능입니다.');
				return;
			}
			let ea = $('#inputQuantity').val();
	         console.log(ea);
	         console.log(bStock);
	         if(ea <= 0){
	            alert('0개 이하는 주문이 안됩니다!');
	            $('#inputQuantity').val(0);
	            return;
	         }
	        if(+(ea) > +(bStock)){
	        	 alert('재고수량을 초과해서 담을수 없습니다. 재고수량:'+bStock);
	        	 return;
	         }
	        location.href='${pageContext.request.contextPath}/product/insertOrder?ea='+ea+'&pNo='+pNo;
		});//바로주문 상품
		
		$('#button-product-list').on('click', function() {
			location.href = '${pageContext.request.contextPath}/product/productList?categoryNo=${categoryNo}';
		});
	});// end jQuery
</script>
