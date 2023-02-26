<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<link href="${pageContext.request.contextPath }/resources/css/boardModify.css" rel="stylesheet">

<%@ include file="../include/header.jsp"%>

<section>
	<div class="container mt-4">
		<div class="row">
			<div class="mb-3">
			  	<div class="col col align-self-center" style="position: relative;">
		        	<nav style="--bs-breadcrumb-divider: url(&#34;data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='8' height='15'%3E%3Cpath d='M2.5 0L1 1.5 3.5 4 1 6.5 2.5 8l4-4-4-4z' fill='%236c757d'/%3E%3C/svg%3E&#34;);" aria-label="breadcrumb">
					  <ol class="breadcrumb" style="margin-bottom: 0; font-size: 25px; color: #ffc107;">
					    <li class="breadcrumb-item mt-1" id="majorTitle">${category.categoryMajorTitle}</li>
					    <li class="breadcrumb-item mt-1" id="minorTitle">${category.categoryMinorTitle}&nbsp;&nbsp;</li>
					  </ol>
					</nav>
		        </div>
			</div>
		</div>
		<div class="row">
			<div class="col mb-1">
				<p>&nbsp;작성자: ${nickName }</p>
			</div>
		</div>
	</div>
	
	<!-- enctype="multipart/form-data" 속성 추가 해야 file이 넘어간다.-->
	<form action="${pageContext.request.contextPath}/board/boardUpdate" method="post" name="updateForm" id="modifyForm" enctype="multipart/form-data">
		
		<div class="col-xs-12 col-md-12 write-wrap container">
			<input type="hidden" name="boardNo" value="${ board.boardNo }">
	      	<input type="hidden" name="boardUserNo" value="${login.userNo}"> 			
			<input type="hidden" name="boardCategoryNo" value="${ board.boardCategoryNo }">
			<div style="line-height: 30px">
			    <label for="exampleFormControlInput1">&nbsp;제목</label>
			       &nbsp;&nbsp;&nbsp; 썸네일 설정하기
				<input type="checkbox" id="thumbnail-checkbox">
				<label for="thumbnail-checkbox"></label>
				<span class="file-upload">
					<i class="note-icon-picture"></i>
					<input name="thumbnail" type="file" class="upload" id="thumbnail-pic" accept="image/*" > <br>
				</span>
				<button type="button" class="sbtn cyan" id="thumbnail-show" >썸네일 미리보기</button>
				<!-- 모달만들어서 썸네일 미리보기 만들어주기. -->
			</div>
			<div class="form-group">
				<input class="form-control" name="boardTitle" maxlength="50" value="${board.boardTitle}">
			</div>
			<div class="form-group boardContent-summernote">
				<textarea class="form-control" id="summernote" rows="10"
					name="boardContent"></textarea>
			</div>
			<div class="mt-3 float-end" style="color: #8c8c8c;">
  					<span class=textCount>0</span>
  					<span class=textTotal>/100000Byte &nbsp;</span>
			</div>

			<br>

			<button type="button" onclick="history.back(-1)" class="sbtn blue small rounded">취소</button>
			<button type="submit" id="updateBtn" class="sbtn cyan small rounded">변경</button>
			<button type="button" id="delBtn" class="sbtn red small rounded">삭제</button>


		</div>
	</form>
</section>




<%@ include file="../include/footer.jsp"%>


<script>
	
	$(document).ready(function() {
		let boardFileJsonArray = [];
		
		
	    $('#summernote').summernote({
	      height: 500,                 // 에디터 높이
	      minHeight: null,             // 최소 높이
	      maxHeight: null,             // 최대 높이
	      focus: false,                  // 에디터 로딩후 포커스를 맞출지 여부
	      lang: "ko-KR",					// 한글 설정
	      toolbar: [
	          // 글꼴 설정
	          ['fontname', ['fontname']],
	          // 글자 크기 설정
	          ['fontsize', ['fontsize']],
	          // 굵기, 기울임꼴, 밑줄,취소 선, 서식지우기
	          ['style', ['bold', 'italic', 'underline','strikethrough', 'clear']],
	          // 글자색
	          ['color', ['color']],
	          // 표만들기
	          ['table', ['table']],
	          // 글머리 기호, 번호매기기, 문단정렬
	          ['para', ['ul', 'ol', 'paragraph']],
	          // 줄간격
	          ['height', ['height']],
	          // 그림첨부, 링크만들기, 동영상첨부 ['picture','video']
	          ['insert', ['picture']],
	          // 코드보기, 확대해서보기, 도움말
	          ['view', ['codeview']]
	        ],
	      // 추가한 글꼴
	      fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New','맑은 고딕','궁서','굴림체','굴림','돋음체','바탕체','GangwonEdu_OTFBoldA'],
	      // 추가한 폰트사이즈
	      fontSizes: ['8','9','10','11','12','14','16','18','20','22','24','28','30','36','50','72'],
	      callbacks: {
				// onImageUpload : function(files) {
			    onImageUpload : function(files, editor, welEditable) {
					/* uploadSummernoteImageFile(files[0],this);*/
					for (let i = files.length - 1; i >= 0; i--) {
	                    uploadSummernoteImageFile(files[i], this);
	                }
				},
				onPaste: function (e) {
					let clipboardData = e.originalEvent.clipboardData;
					if (clipboardData && clipboardData.items && clipboardData.items.length) {
						let item = clipboardData.items[0];
						if (item.kind === 'file' && item.type.indexOf('image/') !== -1) {
							e.preventDefault();
						}
					}
				}
	      }
	    });
	    $('#summernote').summernote('fontName', 'GangwonEdu_OTFBoldA');
	    
	    function uploadSummernoteImageFile(file, editor) {
	    	
			let formData = new FormData();
			formData.append('file', file);
			formData.append('categoryNo', '${board.boardCategoryNo}');
	
			$.ajax({
				data : formData,
				type: 'POST',
				url: '<c:url value="/board/uploadSummernoteImageFile"/>',
				enctype: 'multipart/form-data',
				cache: false,
				contentType : false,
				processData : false,
				success : function(result) {
					console.log(result);
					boardFileJsonArray.push(result);
					$(editor).summernote('insertImage', result["url"]);
				},
				error : function(e) {
				    console.log(e);
				}
			});
		}
	    
	   //새로고침, 브라우저 종료, 뒤로가기 감지 이벤트
	   let deleteFiles = [];
	   $(window).on('beforeunload', function() {
	    	
	        // return false or string이면 alert을 띄워준다.
	        return false;
	   });
	   
	   // unload 시 ajax 가능.
	   $(window).on('unload', function() {
		   deleteTempFile();
		   $('#summernote').summernote('reset');
	   });
	   
	    //폼 submit 때는 경고창 뜨지 않도록 하기
	    $(document).on("submit", "form", function(event){
	        $(window).off('beforeunload');
	    });
	    
	    // 다른 페이지로 넘어갈때 temp폴더의 이미지를 지움.
	    function deleteTempFile() {
		   
	    	for(let i = 0; i<boardFileJsonArray.length; i++){
	            console.log('반복문 동작!');
	            let str = boardFileJsonArray[i].url;
	            console.log(str);
	            let result = str.split('/');
	            console.log('정제된 데이터: ' + result);
	            deleteFiles.push(result[3]);
	      	}
	    	
	      console.log(deleteFiles);
	      
	      $.ajax({
	         type: 'post',
	         contentType: 'application/json',
	         url: '${pageContext.request.contextPath}/board/tempDelete',
	         data: JSON.stringify(deleteFiles)
	      });
		} // end deleteTempFile()
	 
	   /*  
	    $('.note-editable').click(function() {
			console.log('기본 이벤트!');
			
			let boardContent = $('.note-editable').html();
			let boardContentLength = boardContent.length;
			let boardContentByteLength = 0;
			
			boardContentByteLength = (function(s,b,i,c) {
				for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?3:c>>7?2:1);
				return b
			})(boardContent);
			
			$('.textCount').text(boardContentByteLength);
		
		}); 
	     */
	    
		$('.boardContent-summernote').keydown(function() {
			console.log('키 이벤트 발생');
			
			// textarea 값
			let boardContent = $('.note-editable').html();
			
			// textarea length
			let boardContentLength = boardContent.length;
			let boardContentByteLength = 0;
			
			console.log(boardContent, 'boardContent');
			console.log(boardContentLength, 'boardContentLength');
			
			boardContentByteLength = (function(s,b,i,c) {
				for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?3:c>>7?2:1);
				return b
			})(boardContent);
		
			if(boardContentByteLength >= 100000) {
				alert('글자수 제한!');
				return;
			};
			
			console.log('boardContentByteLength', boardContentByteLength);
			$('.textCount').text(boardContentByteLength);
			
		}); // 글자 수 event 끝.
	
	    
	    
		$('#updateBtn').click(function(e) {
			e.preventDefault();
			
			const bno = '${ board.boardNo }';
			const no = '${board.boardCategoryNo}';
			console.log(bno);
			console.log(no);
			
			console.log('글 등록 버튼 이벤트 발생!');
	    	// textarea 값
			let boardContent = $('.note-editable').html();  
			
			// textarea length
			let boardContentLength = boardContent.length;
			let boardContentByteLength = 0;
			
			console.log(typeof(boardContent), 'boardContentByteLength');
			console.log(boardContentLength, 'boardContentLength');
			
			
			boardContentByteLength = (function(s,b,i,c) {
				for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?3:c>>7?2:1);
				return b
			})(boardContent);
			
			
			if($('input[name=boardTitle]').val().trim() === '') {
				alert('제목은 필수 항목입니다.');
				return;
			} else if($('#summernote').val().trim() === '') {
				alert('내용은 필수 항목입니다!');
				return;
			} else if(boardContentByteLength >= 100000) {
				alert('내용은 100000byte를 넘을 수 없습니다.');
				return;
			}  else if(boardContentByteLength === '11') {
				alert('100000byte를 넘을 경우 글을 수정할 수 없습니다!');
				return;
			} else {
	             console.log('boardFileJsonArray: ' + boardFileJsonArray);
	             console.log('길이: ' + boardFileJsonArray.length);
	             
	             for(let i = 0; i<boardFileJsonArray.length; i++){
	                console.log('반복문 동작!');
	                let str = boardFileJsonArray[i].url;
	                console.log(str);
	                // str의 값 : /board/summernoteImage/152210d9-a713-43ff-b81c-d9f1a3de0303(BN_CN10).jpg 
	                // '='를 기준으로 자른다.
	                let result = str.split('/');
	                console.log('정제된 데이터: ' + result);
	
	                const $input = document.createElement('input');
	                $input.setAttribute('name', 'filename');
	                $input.setAttribute('type', 'hidden');
	                $input.setAttribute('value', result[3]);
	
	                document.getElementById('modifyForm').appendChild($input);
	                
	             }  
				$('#modifyForm').submit();
			}
				
		}); //수정 버튼 이벤트 처리 끝.

		$('#summernote').summernote('pasteHTML', `${board.boardContent}`);
		
	    $('#thumbnail-checkbox').click(function() {
	    	if ($('#thumbnail-checkbox').is(":checked")) {
	    		$('.file-upload').css('display','inline-block');
	    		
	    	} else {
	    		$('.file-upload').css('display','none');
	    		
				const dt = new DataTransfer();
	    		$("#thumbnail-pic")[0].files = dt.files;
	    	}
    	});
	    
		$('#delBtn').click(function() {
			if (confirm('정말 삭제하시겠습니까?')) {
				$('form[name=updateForm]').attr('action', '${pageContext.request.contextPath}/board/boardDelete');
				
				$('form[name=updateForm]').submit();
			}
		})

	  }); 
	
	// 이미지 파일을 올릴 시 미리보기 기능.
	// 함수작성을 위한 빈 파일이 들어간 노드를 가져온다.
	const input = document.querySelector('#thumbnail-pic');
	
	// 함수를 호출할때 실제 노드가 매개변수로 온다.
	function readURL(input) {
		if (input.files && input.files[0]) {
			let reader = new FileReader();
			
			reader.onload = function (e) {
			 $('#image_section').attr('src', e.target.result);  
			}
			
			reader.readAsDataURL(input.files[0]);
		}
	}
	 
    // 프로필 이미지파일 제한
	// 이벤트를 바인딩해서 input에 파일이 올라올때 (input에 change를 트리거할때) 위의 함수를 this context로 실행합니다.
	$("#thumbnail-pic").change(function(){
		
		if (this.files[0]) {
			if (!this.files[0].type.includes('image/')) {
				alert("이미지 파일만 등록 가능합니다.");
				const dt = new DataTransfer();
				this.files = dt.files;
				
				 $('#image_section').attr('src', '<c:url value="/resources/img/BoardThumbnail.png" />');  
				return;
			} else {
				readURL(this);				
			}
		} else {
			 $('#image_section').attr('src', '<c:url value="/resources/img/BoardThumbnail.png" />');  
			readURL(this);
		}
	});	
</script>