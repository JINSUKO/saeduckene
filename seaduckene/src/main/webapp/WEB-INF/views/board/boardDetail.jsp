<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>


<%@ include file="../include/header.jsp"%>



<div class="container">
	<div class="card" style="width: 18rem;" id="board-detail-card">
		<div class="card-body" id="board-detail-card-body">
			<h5 class="card-title">~~게시판 입니다.</h5>
			<p class="card-text">~~게시판에 걸맞는 글을 작성해 주세요.</p>
			<button id="board-detail-card-body-button" type="button"
				class="btn btn-primary">Home</button>
		</div>
	</div>
</div>


<div class="container text-center">
	<div class="row">
		<div class="col d-flex flex-row justify-content-end"
			id="board-detail-item">

			<p>
				<fmt:formatDate value="${list.boardRegDate}" pattern="MM-dd HH:mm" />
			</p>
			<!-- 			<li class="nav-item"><a href="#" class="nav-link">추천</a></li>
				<li class="nav-item"><a href="#" class="nav-link">조회</a></li> -->

		</div>
	</div>
</div>


<form action="${pageContext.request.contextPath}/board/boardModify"
	id="writeForm" method="post">

	<div class="container">
		<div class="card mb-4">
			<div class="card-body">
				<div class="mb-3">
					<input type="hidden" name="boardNo" value="${ list.boardNo }">
					<label for="title" class="form-label">제목</label> <input type="text"
						class="form-control" id="title" name="boardTitle"
						value="${list.boardTitle}" readonly>
				</div>
				<div class="mb-3" id="board-detail-content">
					<label for="content" class="form-label">내용</label>
					<textarea class="form-control" id="summernote" name="boardContent"
						readonly rows="15"></textarea>

				</div>
				<div id="board-detail-button">
					<a href='<c:url value='/board/boardList'/>'
						class="right btn btn-info" id="modallistBtn">목록가기</a>
					<button type="submit" class="right btn btn-info" id="ModBtn">수정하기</button>
				</div>
			</div>
		</div>
	</div>
</form>

<div class="container">
	<div class="card-body">
		<div class="row gx-5">
		
		<!-- 로그인 안 했을 시 -->
			<c:if test="${login == null}">
				<div class="col-auto">
					<div class="avatar avatar-online">
						<img src="assets/img/avatars/6.jpg" alt="#" class="avatar-img" style="display:none;">
					</div>
				</div>

				<div class="col">
					<div class="d-flex align-items-center mb-3">
						<h5 class="me-auto mb-0" id="replyBoardNo" style="display:none;"></h5>
						<span class="text-muted extra-small ms-2" style="display:none;"></span>
					</div>

					<div class="d-flex align-items-center">
						<input type="hidden" value="${login.userNo}" id="replyUserNo"></input>
						<textarea class="form-control" rows="3" id="reply" style="display:none;"></textarea>
					</div>
					<br>
					<div>
						<button type="button" id="replyRegist" class="right btn btn-info" style="display:none;">등록하기</button>
					</div>
				</div>
			</c:if>
			
			<!-- 로그인 시 -->
			<c:if test="${login != null}">
				<div class="col-auto">
					<div class="avatar avatar-online">
						<img src="assets/img/avatars/6.jpg" alt="#" class="avatar-img">
					</div>
				</div>

				<div class="col">
					<div class="d-flex align-items-center mb-3">
						<h5 class="me-auto mb-0" id="replyBoardNo">${login.userNickname}</h5>
					</div>

					<div class="d-flex align-items-center">
						<input type="hidden" value="${login.userNo}" id="replyUserNo"></input>
						<textarea class="form-control" rows="3" id="reply"></textarea>
					</div>
					<br>
					<div>
						<button type="button" id="replyRegist" class="right btn btn-info">등록하기</button>
					</div>
				</div>
			</c:if>
			
			
			

			<hr>

			<div id="replyList">
				<!-- <div class=col>
				<div class="d-flex align-items-center mb-3"></div>
				<div class="reply-content"> <strong class='left'>nick</strong>
					<small class='left'>date</small> <a href='#' class='right'>
					<textarea class="form-control" rows="3" id="reply"></textarea>
					<a href='#' class='right'><span class='glyphicon glyphicon-pencil'></span>수정</a> 
					<a href='#' class='right'><span class='glyphicon glyphicon-remove'></span>삭제</a>
				</div>
				<p class='clearReply'>댓글</p>
			</div>
			<button type="button" class="form-control" id="moreList">더보기</button> -->
			</div>
			
		</div>
		<br>
		 <button type="button" class="form-control" id="moreList">더보기(페이징)</button>
	</div>
	<hr>
</div>


<!-- 모달  -->
<div class="modal fade" id="replyModal" role="dialog">
	<div class="modal-dialog modal-md">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="btn btn-default pull-right"
					data-dismiss="modal">닫기</button>
				<h4 class="modal-title">댓글수정</h4>
			</div>
			<div class="modal-body">
				<!-- 수정폼 id값을 확인하세요-->
				<div class="reply-content">
					<textarea class="form-control" rows="4" id="modalReply"
						placeholder="내용입력"></textarea>
					<div class="reply-group">
						<div class="reply-input">
							<input type="hidden" id="modalRno"> 
						</div>
						<button class="right btn btn-info" id="modalModBtn">수정하기</button>
						<button class="right btn btn-info" id="modalDelBtn">삭제하기</button>
					</div>
				</div>
				<!-- 수정폼끝 -->
			</div>
		</div>
	</div>
</div>






<script>
	$(document).ready(function() {

		$(function() {
			$('#summernote').summernote({
				toolbar : false
			});
			$('#summernote').summernote('disable');
			$('#summernote').summernote('pasteHTML', '${list.boardContent}');
			$('.note-statusbar').hide();
			$('.note-editable').css('background', '	#FFFFFF');
		});

		$('#replyRegist').click(function() {

			const boardNo = '${list.boardNo}';
			const reply = $('#reply').val();
			const replyUserNo = $('#replyUserNo').val();
			console.log('dwadwadwa' + replyUserNo);
			console.log(reply);
			console.log(boardNo);

			/* const data = {
					"boardNo":boardNo,
					"reply":reply,
					"replyBoardNo":replyBoardNo,
					"replyUserNo":replyUserNo
			};
			console.log(data); */

			/* if(reply === '') {
				alert('내용을 입력하세요!')
				return;
			} */
			
			if($('#reply').val().trim() === '' ) {
				alert('내용을 입력해주세요!');
				return;
			}

			$.ajax({
				type : 'post',
				url : '<c:url value="/reply/replyRegist" />',
				data : JSON.stringify({
					"replyBoardNo" : boardNo,
					"replyContent" : reply,
					"replyUserNo" : replyUserNo
				}),
				dataType : 'text',
				contentType : 'application/json',
				success : function(data) {
					console.log('통신 성공!: ' + data);
					$('#reply').val('');
					getList(1, true);
				},
				error : function() {
					alert('등록에 실패했습니다. 관리자에게 문의해주세요.');
				}

			}); //ajax 끝.

		});//댓글 등록 이벤트 끝.
		
		//댓글 등록 키 이벤트
		$('#reply').keyup(function(e) {
			if(e.key === 'Enter') {
				$('#replyRegist').click();
			} else {
				return;
			}
		}); //키이벤트 끝
		
		//더보기 이벤트
		$('#moreList').click(function() {
			getList(++page, false);
		});
	
	
		
		
		
		let page = 1;
		let strAdd = '';

		getList(1, true);

		function getList(pageNum, reset) {

			const bno = '${list.boardNo}';
			
			$.getJSON(
					"<c:url value='/reply/getList/' />" + bno + "/" + pageNum,
					function(data) {
						console.log('ㅎㅎㅎ', data);
						
						console.log("data " + data.total);
							
						let total = data.total;
						let replyList = data.list;
						
						console.log("total "+ total);
						console.log("reply ", replyList);
						
						if(reset) {
							strAdd = '';
							page = 1; 
						}
						
						console.log('현재 페이지: ' + page);
						/* console.log('인규: ' + replyList.userNickname); */
						if(total <= page * 5) {
							$('#moreList').css('display', 'none');
						} else {
							$('#moreList').css('display', 'block');
						}
						/* console.log("최고인규" + data.length); */
						if(data.length <= 0) return;
						
						for(let i=0; i<replyList.length ; i++) {
							strAdd +=
								`<div class="col">
					<div class="d-flex align-items-center mb-3"></div>
						<div class="reply-content"> <strong class='left'>`+ replyList[i].userNickname +`</strong> &nbsp&nbsp&nbsp
							<small class='left'>` + timeStamp(replyList[i].replyRegDate) + `</small>
							<p data-reply-no="` + replyList[i].replyNo + `" class="form-control mt-2" id="reply" style="min-height: 5rem;">` + replyList[i].replyContent.replaceAll('\r', '<br>') + `</p></a>
						</div>
					
				</div>`; 
						}
						
						$('#replyList').html(strAdd);
					}		
			)
		} //get List끝
		
		$('#replyList').on('click', '.reply-content > #reply', function(e) {
			e.preventDefault();
			
			if ('${login.userNickname}' === $(this)[0].parentNode.firstElementChild.textContent){
				const replyNo = $(this).data('replyNo');
				console.log("바보 아님" + replyNo);
				$('#modalRno').val(replyNo);
				$('#modalReply').val($(this).text());
				$('#replyModal').modal('show');
				}
			
		}); //rpleyList click event 끝.
		
		$('#modalModBtn').click(function() {
			
			const reply = $('#modalReply').val();
			const replyNo = $('#modalRno').val();
			/* const replyPw = '${login.userPw}'; */
			
			console.log('reply : ' + reply);
			console.log('replyNo : ' + replyNo);
			/* console.log('replyPw: ', replyPw); */
			
			/* if(reply === '' || replyPw === '') {
				alert('내용, 비밀번호 입력 부탁드려요!')
				return;
			} */
		 
			$.ajax({
				type: 'post',
				url: '<c:url value="/reply/update" />',
				contentType: 'application/json',
				data: JSON.stringify({
					'replyContent': reply,
					'replyNo': replyNo,
/* 					'replyPw' : replyPw */
				}),
				success : function(result) {
					alert('정상 수정되었습니다.');
					$('#modalReply').val('');
					/* 	$('#modalPw').val(''); */
					$('#replyModal').modal('hide'); 
					getList(1, true);
				},
				error: function() {
					alert('수정에 실패했습니다. 관리자에게 문의하세요!');
				}
				
			}); //end ajax(수정) 
			
		
		}); //modalModBtn click event 수정 끝.
		
		$('#modalDelBtn').click(function() {
			
			const replyNo = $('#modalRno').val();
			
			$.ajax({
				type: 'post',
				url: '<c:url value="/reply/delete" />',
				data: JSON.stringify({
					'replyNo': replyNo
				}),
				contentType: 'application/json',
				success: function(data) {
					alert('댓글이 삭제되었습니다.');
					$('#replyModal').modal('hide'); 
					getList(1, true);
				},
				error: function() {
					alert('수정 실패! 관리자에게 문의하세요!');
				}
				
			}) //ajax 끝.
			
			
			
			
		}) //modalDelBtn click event 끝.
		
		
		
		
		
		
		//날짜 처리 함수
		function timeStamp(millis) {
			const date = new Date(); //현재 날짜
			//현재 날짜를 밀리초로 변환 - 등록일 밀리초 -> 시간 차
			const gap = date.getTime() - millis;
			
			let time; //리턴할 시간
			if(gap < 30 * 30 * 12 * 10) { //1일 미만일 경우
				if(gap < 30 * 30 * 10) { //1시간 미만일 경우
					time = '방금 전';
				} else {
					time = parseInt(gap / (1 * 30 * 30)) + '시간 전';
				}
			} else { //1일 이상인 경우
				const regDate = new Date(millis);
				const year = regDate.getFullYear(); //년
				const month = regDate.getMonth() + 1; //월
				const day = regDate.getDate(); //일
				
				time = year + '월' + month + '년' + day + '일';
			}
			
			return time;
		}//날짜 처리함수 끝

	})
</script>
<%@ include file="../include/footer.jsp"%>
