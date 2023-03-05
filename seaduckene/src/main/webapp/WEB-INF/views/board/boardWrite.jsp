<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<link href="${pageContext.request.contextPath }/resources/css/boardWrite.css" rel="stylesheet">

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
	<form action="${pageContext.request.contextPath}/board/boardWrite" id="writeForm" method="post" enctype="multipart/form-data">
	
	   <div class="container">
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
	        <input type="text" class="form-control" id="exampleFormControlInput1" name="boardTitle" placeholder="제목을 작성해주세요." maxlength="50" />
	      </div>
	
	      <div class="form-group boardContent-summernote">
	      	<textarea class="form-control" id="summernote" rows="10" name="boardContent"></textarea>
	      	<!-- <input type="hidden" id="summernote" name="boardContent"></input> -->
	      </div>
	      	<div class="mt-3 float-end" style="color: #8c8c8c;">
	      		<span class=textCount>0</span>
	      		<span class=textTotal>/100000Byte &nbsp;</span>
	      	</div>
	      <input type="hidden" name="boardUserNo" value="${login.userNo}"> 
	      <input type="hidden" name="boardCategoryNo" value="${categoryNo}"> <br>
	
	      <div>
	
	         <button type="button" class="sbtn cyan small rounded" id="board-Write-button">등록하기</button>
	         <a href='<c:url value='/board/boardList/${categoryNo}'/>' class="sbtn blue small rounded" 
	            id="WritelistBtn">목록으로</a>
	      </div>
	
	   </div>
	</form>
</section>

<%@ include file="../include/footer.jsp"%>


<script>                                                                                                                                                                                                                                                 

	$(document).ready(function() {
		let boardFileJsonArray = [];
		
			
		// https://programmer93.tistory.com/31 여기서 봄
		// summernote 이미지파일을 올릴 때 비동기로 temp폴더에 넣는다.
		// 업로드 할때 temp폴더의 이미지 파일을 board폴더로 복사하고,
		// temp폴더의 이미지 파일을 전부 지우는 방식으로 동작한다.
	    $('#summernote').summernote({
	      height: 500,                 // 에디터 높이
	      minHeight: null,             // 최소 높이
	      maxHeight: null,             // 최대 높이
	      focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
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
			// 그림첨부, 링크만들기, 동영상첨부
			['insert',['picture']]
	        // 코드보기, 확대해서보기, 도움말
	        //, ['view', ['codeview']]
	        ],
	      // 추가한 글꼴
	      fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New','맑은 고딕','궁서','굴림체','굴림','돋음체','바탕체', "GangwonEdu_OTFBoldA"],
	      // 추가한 폰트사이즈
	      fontSizes: ['8','9','10','11','12','14','16','18','20','22','24','28','30','36','50','72'],
	      icons: {
	    	  caret: `"<i`
	      },
	      disableDragAndDrop: true,
	      callbacks: {	//여기 부분이 이미지를 첨부하는 부분
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
	    
	    function uploadSummernoteImageFile(file, editor) {
	
			let formData = new FormData();
			formData.append('file', file);
			formData.append('categoryNo', '${categoryNo}');
	
			$.ajax({
				data : formData,
				type : 'POST',
				<!--  c:url 태그는 url로 요청을 보낸다.-->
				url : '<c:url value="/board/uploadSummernoteImageFile"/>',
				enctype: 'multipart/form-data',
				cache: false,
				contentType : false,
				processData : false,
				success : function(result) { // result는 자바스크립트 객체이다. api로 넘어올떄 string(json)을 자바스크립트 객체로 변환해주는듯.
	            	//항상 업로드된 파일의 url이 있어야 한다.
	                boardFileJsonArray.push(result);
					$(editor).summernote('insertImage', result.url);
				}
			});
		}
	    
	   //새로고침, 브라우저 종료, 뒤로가기 감지 이벤트
	   $(window).on('beforeunload', function() {
	       // return false or string이면 alert을 띄워준다. 
		   return false;
	   });
		 
	   // unload 시 ajax 가능.
	   $(window).on('unload', function() {
		   deleteTempFile();
		   /* $('#summernote').summernote('reset'); */
	   });
	   
	    //폼 submit 때는 경고창 뜨지 않도록 하기
	    $(document).on("submit", "form", function(event){
	        $(window).off('beforeunload');
	    });
	    
	    // 다른 페이지로 넘어갈때 temp폴더의 이미지를 지움.
	    function deleteTempFile() {
	      let deleteFiles = [];
	    	for(let i = 0; i<boardFileJsonArray.length; i++){
	            let str = boardFileJsonArray[i].url;
	            let result = str.split('/');
	            deleteFiles.push(result[3]);
	      }
	
	      
	      $.ajax({
	         type: 'post',
	         contentType: 'application/json',
	         url: '${pageContext.request.contextPath}/board/tempDelete',
	         data: JSON.stringify(deleteFiles)
	      });
		} // end deleteTempFile()
	    
	    
		$('.boardContent-summernote').keydown(function() {
			
			// textarea 값
			let boardContent = $('.note-editable').html();
			
			// textarea length
			let boardContentLength = boardContent.length;
			let boardContentByteLength = 0;
			
			
			
			boardContentByteLength = (function(s,b,i,c) {
				for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?3:c>>7?2:1);
				return b
			})(boardContent);
		
			if(boardContentByteLength >= 100000) {
				alert('글자수 제한!');
				return;
			};
			
			$('.textCount').text(boardContentByteLength);
			
		});
			
			
		
	    
		
	    $('#board-Write-button').click(function() {
	    	// textarea 값
			let boardContent = $('.note-editable').html();
			
			// textarea length
			let boardContentLength = boardContent.length;
			let boardContentByteLength = 0;
			
			boardContentByteLength = (function(s,b,i,c) {
				for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?3:c>>7?2:1);
				return b
			})(boardContent);
	        
	        if($('input[name=boardTitle]').val().trim() === '') {
	           alert('제목은 필수 항목입니다.');
	           return;
	          } else if($('textarea[name=boardContent]').val().trim() === '') {
	             alert('내용은 필수 항목입니다.');
	             return;
	          } else if(boardContentByteLength >= 100000) {
	         	alert('내용은 100000byte를 넘을 수 없습니다.');
	         	return;
	          } else {
	             
	             for(let i = 0; i<boardFileJsonArray.length; i++){
	                let str = boardFileJsonArray[i].url;
	                // str의 값 : /board/summernoteImage/152210d9-a713-43ff-b81c-d9f1a3de0303(BN_CN10).jpg 
	                // '='를 기준으로 자른다.
	                let result = str.split('/');
	
	                const $input = document.createElement('input');
	                $input.setAttribute('name', 'filename');
	                $input.setAttribute('type', 'hidden');
	                $input.setAttribute('value', result[3]);
	
	                document.getElementById('writeForm').appendChild($input);
	                
	             }            
	             $('#writeForm').submit();
	             
	          }
	     });
	    
	    $('#thumbnail-checkbox').click(function() {
	    	if ($('#thumbnail-checkbox').is(":checked")) {
	    		$('.file-upload').css('display','inline-block');
	    		
	    	} else {
	    		$('.file-upload').css('display','none');
	    		
				const dt = new DataTransfer();
	    		$("#thumbnail-pic")[0].files = dt.files;
	    	}
    	});
	    
	    
	 });// end jQuery
	
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
