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
	          ['insert', ['picture']]
	          // 코드보기, 확대해서보기, 도움말
	          //, ['view', ['codeview']]
	        ],
	      // 추가한 글꼴
	      fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New','맑은 고딕','궁서','굴림체','굴림','돋음체','바탕체'],
	      // 추가한 폰트사이즈
	      fontSizes: ['8','9','10','11','12','14','16','18','20','22','24','28','30','36','50','72'],
	      icons: {
	    	  bold: "<svg fill=\"#000000\" width=\"14px\" height=\"20px\" viewBox=\"-6.5 0 32 32\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\"><g id=\"SVGRepo_bgCarrier\" stroke-width=\"0\"></g><g id=\"SVGRepo_tracerCarrier\" stroke-linecap=\"round\" stroke-linejoin=\"round\"></g><g id=\"SVGRepo_iconCarrier\"> <title>bold</title> <path d=\"M0 25.531v1.344c1.063-0.031 1.938-0.063 2.563-0.094 0.625 0 1.094-0.031 1.313-0.031 1.656-0.125 3.063-0.219 4.281-0.188l2.813 0.063c2.438 0 4.25-0.313 5.75-1 0.719-0.344 1.344-0.844 1.969-1.531 0.469-0.469 0.813-1.031 1.031-1.656 0.25-0.844 0.375-1.594 0.375-2.281 0-2.5-1.719-4.625-5.094-5.406 0.531-0.25 1.031-0.5 1.375-0.688s0.625-0.313 0.781-0.438c1.188-0.875 1.781-1.906 1.781-3.281 0-0.594-0.094-1.188-0.281-1.719-0.375-1.094-1.219-2-2.406-2.563-0.531-0.313-1.031-0.469-1.375-0.531-0.938-0.25-1.844-0.375-2.719-0.375h-1.094c-0.219 0-0.406 0-0.531-0.031h-0.5c-0.063 0-0.156 0-0.25 0.031h-0.625l-5.406 0.156-3.719 0.094 0.063 1.188c0.875 0.125 1.406 0.188 1.625 0.188 0.438 0 0.781 0.094 0.969 0.219 0.094 0 0.156 0.063 0.188 0.125 0.063 0.219 0.125 0.688 0.156 1.563 0.063 1.563 0.063 2.813 0.063 3.75 0.031 0.969 0.031 1.625 0.094 2v7.031c0 1.219-0.031 2.125-0.156 2.75-0.031 0.219-0.125 0.438-0.281 0.688-0.438 0.188-1 0.375-1.75 0.469-0.375 0.063-0.719 0.125-1 0.156zM7.719 14.281v-2.469c0.063-1.719 0-2.969-0.031-3.969-0.063-0.438-0.063-0.844-0.063-1.063 0.75-0.156 1.344-0.219 1.844-0.219 1.625 0 2.844 0.344 3.656 1.094 0.813 0.688 1.219 1.563 1.219 2.656 0 2.969-1.75 4.094-5.063 4.094-0.563 0-1.094-0.031-1.563-0.125zM7.719 20.406v-4.5c0.313-0.063 0.75-0.125 1.438-0.125 1.594-0.031 2.813 0.125 3.563 0.438 1.531 0.563 2.594 2.188 2.594 4.344 0 1.031-0.219 1.844-0.563 2.563-0.375 0.719-0.906 1.219-1.719 1.594-1.656 0.781-3.719 0.719-5.125 0.125-0.094-0.25-0.125-0.438-0.125-0.594z\"></path> </g></svg>",
	    	  italic: "<svg fill=\"#000000\" width=\"14px\" height=\"20px\" viewBox=\"-9 0 32 32\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\"><g id=\"SVGRepo_bgCarrier\" stroke-width=\"0\"></g><g id=\"SVGRepo_tracerCarrier\" stroke-linecap=\"round\" stroke-linejoin=\"round\"></g><g id=\"SVGRepo_iconCarrier\"> <title>italic</title> <path d=\"M0.25 25.25l-0.25 1.125c0.094 0 0.25 0 0.5-0.031 0.188 0 0.5-0.031 0.844-0.063 1.094-0.125 1.938-0.188 2.469-0.156h2.719c0.594 0.063 1.094 0.125 1.438 0.188 0.313 0.031 0.531 0.031 0.594 0.031 0.094 0.063 0.188 0.063 0.25 0.063h0.344c0.094 0 0.219 0 0.375-0.031h0.156c0.031-0.031 0.094-0.031 0.156-0.031 0.063-0.094 0.094-0.219 0.094-0.313s0.063-0.156 0.094-0.219c0-0.125 0.031-0.219 0.031-0.375 0-0.094 0.031-0.25 0.031-0.406-0.25-0.031-0.469-0.094-0.625-0.125s-0.25-0.031-0.281-0.031c-0.531-0.063-1.031-0.156-1.656-0.281-0.031-0.094-0.031-0.156-0.031-0.219v-0.156l0.188-0.594 0.563-3.188 0.563-2.125 0.844-4.25c0.156-0.969 0.5-2.313 0.906-4.125 0.031-0.281 0.094-0.656 0.188-1.094 0.125-0.5 0.219-0.875 0.344-1.188 0.344-0.125 0.813-0.281 1.406-0.438 0.531-0.125 1.094-0.25 1.531-0.406 0.063-0.281 0.125-0.531 0.188-0.688 0-0.094 0.031-0.188 0.031-0.281 0.031-0.063 0.031-0.156 0.031-0.25-0.094 0-0.281 0-0.531 0.031-0.25 0-0.531 0.031-0.906 0.063-1.406 0.094-2.375 0.125-3 0.125h-0.344c-0.188 0-0.406-0.031-0.688-0.031l-4.406-0.188-0.281 1.406h0.25c0.063 0.031 0.219 0.031 0.313 0.031 0.969 0.063 1.594 0.188 2 0.375v0.563l-0.125 0.625-0.281 1.844-0.219 0.875-0.438 2.125c0 0.031-0.094 0.344-0.25 0.844-0.156 0.531-0.344 1.313-0.531 2.406l-0.156 0.875-0.813 3.625-0.375 1.844c-0.094 0.563-0.313 1.063-0.563 1.406-0.375 0.156-0.875 0.375-1.625 0.531-0.469 0.125-0.875 0.188-1.063 0.281z\"></path> </g></svg>",
	    	  underline: "<svg fill=\"#000000\" width=\"14px\" height=\"20px\" viewBox=\"-5.5 0 32 32\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\"><g id=\"SVGRepo_bgCarrier\" stroke-width=\"0\"></g><g id=\"SVGRepo_tracerCarrier\" stroke-linecap=\"round\" stroke-linejoin=\"round\"></g><g id=\"SVGRepo_iconCarrier\"> <title>underline</title> <path d=\"M0 5.656l0.063 1.156c0.125 0.031 0.313 0.063 0.563 0.063 0.5 0 1.094 0.031 1.531 0.156s0.563 0.375 0.625 0.844c0.063 0.5 0.063 1.125 0.063 1.656v4.938c0 1.656 0.094 3.125 0.594 4.344 0.531 1.219 1.469 2.219 3.188 2.844 1.219 0.438 2.563 0.625 3.875 0.625s2.813-0.219 4.156-0.688c1.313-0.469 2.5-1.313 3.25-2.531 0.313-0.563 0.531-1.375 0.656-2.219 0.094-0.813 0.125-1.563 0.125-2.25 0-0.219 0-0.969-0.063-1.844 0-0.438-0.031-0.906-0.031-1.406-0.063-1-0.094-1.875-0.125-2.469-0.031-0.25-0.063-0.438-0.063-0.5-0.063-0.25-0.063-0.469-0.063-0.719s0.094-0.438 0.25-0.531c0.344-0.219 0.906-0.281 1.438-0.313 0.25-0.031 0.531-0.063 0.719-0.125 0.063-0.125 0.063-0.25 0.063-0.375 0-0.219-0.031-0.469-0.094-0.688h-0.281c-0.344 0-0.688 0-1.031 0.063-0.344 0.031-0.719 0.063-1.063 0.063-0.781 0-1.5-0.031-2.25-0.094s-1.469-0.094-2.25-0.031v1.094c0.125 0.063 0.438 0.063 0.781 0.063h0.469c0.156-0.031 0.281-0.031 0.344-0.031 0.406 0 0.75 0.156 1.031 0.438 0.063 0.063 0.156 0.313 0.219 0.625 0.063 0.344 0.125 0.75 0.188 1.219 0.094 0.938 0.219 2.094 0.25 3.125 0.063 1.063 0.094 1.938 0.094 2.281 0 2.094-0.313 3.656-1.219 4.719-0.875 1.063-2.281 1.594-4.563 1.594-2.844 0-4.281-1.781-4.438-4.438-0.094-2.469-0.188-4.875-0.188-7.344 0-0.719 0.063-1.25 0.125-1.5 0.156-0.563 0.563-0.656 1.344-0.594 0.344 0.031 0.875 0 1.438-0.094v-0.094c0-0.156 0-0.375-0.031-0.531-0.031-0.188-0.031-0.344 0-0.5-1.75 0.063-3.625 0.125-5.406 0.125-0.594 0-1.25-0.031-1.844-0.063-0.594-0.063-1.281-0.094-1.906-0.094h-0.281c-0.063 0-0.156 0.031-0.25 0.031zM0 26.438h20.813v-2.125h-20.813v2.125z\"></path> </g></svg>",
	    	  strikethrough: "<svg fill=\"#000000\" width=\"14px\" height=\"20px\" viewBox=\"-5 0 32 32\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\"><g id=\"SVGRepo_bgCarrier\" stroke-width=\"0\"></g><g id=\"SVGRepo_tracerCarrier\" stroke-linecap=\"round\" stroke-linejoin=\"round\"></g><g id=\"SVGRepo_iconCarrier\"> <title>strike</title> <path d=\"M0 15.25h21.875v1.938h-21.875v-1.938zM11.563 13.25l2 1.063h-7.969c-0.563-0.844-0.906-1.875-0.906-3.031-0.031-3.625 2.781-6.094 7.406-6.094 1.031 0 2.344 0.125 3.625 0.5 0.406 0.125 0.719 0.188 1.094 0.25 0.25 0.719 0.563 2.438 0.563 4.563 0 0-1.219 0.094-1.25 0.094-0.531-1.625-1.906-3.938-4.188-3.938-2.125 0-3.25 1.375-3.25 2.969 0 1.469 1.281 2.781 2.875 3.625zM13.844 22.563c0-2.063-1.563-3.469-3.188-4.438h6.969c0.344 0.75 0.563 1.625 0.563 2.656 0 3.938-3.219 6.469-8.063 6.469-2.906 0-4.75-0.813-5.406-1.188-0.625-0.719-1.031-3-1.031-5.188l1.219-0.094c0.625 2.063 2.781 5 5.5 5 2.344 0 3.438-1.625 3.438-3.219z\"></path> </g></svg>",
	    	  eraser: "<svg fill=\"#000000\" width=\"14px\" height=\"20px\" viewBox=\"-5.5 0 32 32\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\"><g id=\"SVGRepo_bgCarrier\" stroke-width=\"0\"></g><g id=\"SVGRepo_tracerCarrier\" stroke-linecap=\"round\" stroke-linejoin=\"round\"></g><g id=\"SVGRepo_iconCarrier\"> <title>eraser</title> <path d=\"M2.125 13.781l7.938-7.938c0.719-0.719 1.813-0.719 2.531 0l7.688 7.688c0.719 0.719 0.719 1.844 0 2.563l-7.938 7.938c-2.813 2.813-7.375 2.813-10.219 0-2.813-2.813-2.813-7.438 0-10.25zM11.063 22.75l-7.656-7.688c-2.125 2.125-2.125 5.563 0 7.688s5.531 2.125 7.656 0z\"></path> </g></svg>",
	    	  font: "<svg class=\"note-recent-color\" version=\"1.1\" id=\"svg2\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:cc=\"http://creativecommons.org/ns#\" xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xmlns:svg=\"http://www.w3.org/2000/svg\" xmlns:sodipodi=\"http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd\" xmlns:inkscape=\"http://www.inkscape.org/namespaces/inkscape\" sodipodi:docname=\"font.svg\" inkscape:version=\"0.48.4 r9939\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" width=\"14px\" height=\"20px\" viewBox=\"0 0 1200 1200\" enable-background=\"new 0 0 1200 1200\" xml:space=\"preserve\" fill=\"#000000\"><g id=\"SVGRepo_bgCarrier\" stroke-width=\"0\"></g><g id=\"SVGRepo_tracerCarrier\" stroke-linecap=\"round\" stroke-linejoin=\"round\"></g><g id=\"SVGRepo_iconCarrier\"> <sodipodi:namedview inkscape:cy=\"535.67983\" inkscape:cx=\"1186.0702\" inkscape:zoom=\"0.37249375\" showgrid=\"false\" id=\"namedview30\" guidetolerance=\"10\" gridtolerance=\"10\" objecttolerance=\"10\" borderopacity=\"1\" bordercolor=\"#666666\" pagecolor=\"#ffffff\" inkscape:current-layer=\"svg2\" inkscape:window-maximized=\"1\" inkscape:window-y=\"24\" inkscape:window-height=\"876\" inkscape:window-width=\"1535\" inkscape:pageshadow=\"2\" inkscape:pageopacity=\"0\" inkscape:window-x=\"65\"> </sodipodi:namedview> <path id=\"path8868\" inkscape:connector-curvature=\"0\" d=\"M335.151,763.202h435.208L552.753,199.336L335.147,763.202 M0.004,1192.852 v-84.182h104.038L526.542,7.148h133.42l423.294,1101.521H1200v84.182H768.761v-84.182h131.834l-99.271-260.488H302.581 l-99.272,260.488h130.244v84.182H0\"></path> </g></svg>",
	    	  table: "<svg fill=\"#000000\" width=\"14px\" height=\"20px\" viewBox=\"0 0 16 16\" id=\"table-16px\" xmlns=\"http://www.w3.org/2000/svg\"><g id=\"SVGRepo_bgCarrier\" stroke-width=\"0\"></g><g id=\"SVGRepo_tracerCarrier\" stroke-linecap=\"round\" stroke-linejoin=\"round\"></g><g id=\"SVGRepo_iconCarrier\"> <path id=\"Path_31\" data-name=\"Path 31\" d=\"M-11.5,0h-11A2.5,2.5,0,0,0-25,2.5v11A2.5,2.5,0,0,0-22.5,16h11A2.5,2.5,0,0,0-9,13.5V2.5A2.5,2.5,0,0,0-11.5,0ZM-15,4V7h-4V4Zm5,7h-4V8h4Zm-5,0h-4V8h4Zm0,1v3h-4V12Zm-9-4h4v3h-4Zm4-1h-4V4h4Zm-4,6.5V12h4v3h-2.5A1.5,1.5,0,0,1-24,13.5ZM-11.5,15H-14V12h4v1.5A1.5,1.5,0,0,1-11.5,15ZM-10,7h-4V4h4ZM-24,3V2.5A1.5,1.5,0,0,1-22.5,1h11A1.5,1.5,0,0,1-10,2.5V3Z\" transform=\"translate(25)\"></path> </g></svg>",
	    	  unorderedlist: "<svg width=\"14px\" height=\"20px\" viewBox=\"0 0 24 24\" xmlns=\"http://www.w3.org/2000/svg\" fill=\"#000000\"><g id=\"SVGRepo_bgCarrier\" stroke-width=\"0\"></g><g id=\"SVGRepo_tracerCarrier\" stroke-linecap=\"round\" stroke-linejoin=\"round\"></g><g id=\"SVGRepo_iconCarrier\"> <rect x=\"0\" fill=\"none\" width=\"24\" height=\"24\"></rect> <g> <path d=\"M9 19h12v-2H9v2zm0-6h12v-2H9v2zm0-8v2h12V5H9zm-4-.5c-.828 0-1.5.672-1.5 1.5S4.172 7.5 5 7.5 6.5 6.828 6.5 6 5.828 4.5 5 4.5zm0 6c-.828 0-1.5.672-1.5 1.5s.672 1.5 1.5 1.5 1.5-.672 1.5-1.5-.672-1.5-1.5-1.5zm0 6c-.828 0-1.5.672-1.5 1.5s.672 1.5 1.5 1.5 1.5-.672 1.5-1.5-.672-1.5-1.5-1.5z\"></path> </g> </g></svg>",
	    	  orderedlist: "<svg fill=\"#000000\" width=\"14px\" height=\"20px\" viewBox=\"0 0 24 24\" xmlns=\"http://www.w3.org/2000/svg\"><g id=\"SVGRepo_bgCarrier\" stroke-width=\"0\"></g><g id=\"SVGRepo_tracerCarrier\" stroke-linecap=\"round\" stroke-linejoin=\"round\"></g><g id=\"SVGRepo_iconCarrier\"><path d=\"M3.604 3.089A.75.75 0 014 3.75V8.5h.75a.75.75 0 010 1.5h-3a.75.75 0 110-1.5h.75V5.151l-.334.223a.75.75 0 01-.832-1.248l1.5-1a.75.75 0 01.77-.037zM8.75 5.5a.75.75 0 000 1.5h11.5a.75.75 0 000-1.5H8.75zm0 6a.75.75 0 000 1.5h11.5a.75.75 0 000-1.5H8.75zm0 6a.75.75 0 000 1.5h11.5a.75.75 0 000-1.5H8.75zM5.5 15.75c0-.704-.271-1.286-.72-1.686a2.302 2.302 0 00-1.53-.564c-.535 0-1.094.178-1.53.565-.449.399-.72.982-.72 1.685a.75.75 0 001.5 0c0-.296.104-.464.217-.564A.805.805 0 013.25 15c.215 0 .406.072.533.185.113.101.217.268.217.565 0 .332-.069.48-.21.657-.092.113-.216.24-.403.419l-.147.14c-.152.144-.33.313-.52.504l-1.5 1.5a.75.75 0 00-.22.53v.25c0 .414.336.75.75.75H5A.75.75 0 005 19H3.31l.47-.47c.176-.176.333-.324.48-.465l.165-.156a5.98 5.98 0 00.536-.566c.358-.447.539-.925.539-1.593z\"></path></g></svg>",
	    	  alignLeft: "<svg width=\"14px\" height=\"20px\" viewBox=\"0 0 24 24\" id=\"align-left\" data-name=\"Flat Line\" xmlns=\"http://www.w3.org/2000/svg\" class=\"icon flat-line\" fill=\"#000000\"><g id=\"SVGRepo_bgCarrier\" stroke-width=\"0\"></g><g id=\"SVGRepo_tracerCarrier\" stroke-linecap=\"round\" stroke-linejoin=\"round\"></g><g id=\"SVGRepo_iconCarrier\"><path id=\"primary\" d=\"M3,12H17M3,6H21M3,18H21\" style=\"fill: none; stroke: #000000; stroke-linecap: round; stroke-linejoin: round; stroke-width: 2;\"></path></g></svg>",
	    	  alignCenter: "<svg width=\"14px\" height=\"20px\" viewBox=\"0 0 24 24\" id=\"align-center\" data-name=\"Flat Line\" xmlns=\"http://www.w3.org/2000/svg\" class=\"icon flat-line\" fill=\"#000000\"><g id=\"SVGRepo_bgCarrier\" stroke-width=\"0\"></g><g id=\"SVGRepo_tracerCarrier\" stroke-linecap=\"round\" stroke-linejoin=\"round\"></g><g id=\"SVGRepo_iconCarrier\"><path id=\"primary\" d=\"M6,12H18M3,6H21M3,18H21\" style=\"fill: none; stroke: #000000; stroke-linecap: round; stroke-linejoin: round; stroke-width: 2;\"></path></g></svg>",
	    	  alignRight: "<svg width=\"14px\" height=\"20px\" viewBox=\"0 0 24 24\" id=\"align-right\" data-name=\"Flat Line\" xmlns=\"http://www.w3.org/2000/svg\" class=\"icon flat-line\" fill=\"#000000\"><g id=\"SVGRepo_bgCarrier\" stroke-width=\"0\"></g><g id=\"SVGRepo_tracerCarrier\" stroke-linecap=\"round\" stroke-linejoin=\"round\"></g><g id=\"SVGRepo_iconCarrier\"><path id=\"primary\" d=\"M21,12H7M21,6H3M21,18H3\" style=\"fill: none; stroke: #000000; stroke-linecap: round; stroke-linejoin: round; stroke-width: 2;\"></path></g></svg>",
	    	  alignJustify: "<svg fill=\"#000000\" width=\"14px\" height=\"20px\" viewBox=\"-5 -7 24 24\" xmlns=\"http://www.w3.org/2000/svg\" preserveAspectRatio=\"xMinYMin\" class=\"jam jam-align-justify\"><g id=\"SVGRepo_bgCarrier\" stroke-width=\"0\"></g><g id=\"SVGRepo_tracerCarrier\" stroke-linecap=\"round\" stroke-linejoin=\"round\"></g><g id=\"SVGRepo_iconCarrier\"><path d=\"M1 0h12a1 1 0 0 1 0 2H1a1 1 0 1 1 0-2zm0 8h12a1 1 0 0 1 0 2H1a1 1 0 1 1 0-2zm0-4h12a1 1 0 0 1 0 2H1a1 1 0 1 1 0-2z\"></path></g></svg>",
	    	  outdent: "<svg width=\"14px\" height=\"20px\" viewBox=\"0 0 16 16\" xmlns=\"http://www.w3.org/2000/svg\" fill=\"#000000\"><g id=\"SVGRepo_bgCarrier\" stroke-width=\"0\"></g><g id=\"SVGRepo_tracerCarrier\" stroke-linecap=\"round\" stroke-linejoin=\"round\"></g><g id=\"SVGRepo_iconCarrier\"><path d=\"M5 2a1 1 0 000 2h9a1 1 0 100-2H5zM8 7a1 1 0 000 2h6a1 1 0 100-2H8zM4 13a1 1 0 011-1h9a1 1 0 110 2H5a1 1 0 01-1-1zM3.293 5.293a1 1 0 011.414 1.414L3.414 8l1.293 1.293a1 1 0 01-1.414 1.414l-2-2a1 1 0 010-1.414l2-2z\" fill=\"#000000\"></path></g></svg>",
	    	  indent: "<svg width=\"14px\" height=\"20px\" viewBox=\"0 0 16 16\" xmlns=\"http://www.w3.org/2000/svg\" fill=\"#000000\"><g id=\"SVGRepo_bgCarrier\" stroke-width=\"0\"></g><g id=\"SVGRepo_tracerCarrier\" stroke-linecap=\"round\" stroke-linejoin=\"round\"></g><g id=\"SVGRepo_iconCarrier\"><path d=\"M5 2a1 1 0 000 2h9a1 1 0 100-2H5zM8 7a1 1 0 000 2h6a1 1 0 100-2H8zM4 13a1 1 0 011-1h9a1 1 0 110 2H5a1 1 0 01-1-1zM2.707 5.293a1 1 0 00-1.414 1.414L2.586 8 1.293 9.293a1 1 0 001.414 1.414l2-2a1 1 0 000-1.414l-2-2z\" fill=\"#000000\"></path></g></svg>",
	    	  textHeight: "<svg fill=\"#000000\" width=\"14px\" height=\"20px\" viewBox=\"0 -32 576 576\" xmlns=\"http://www.w3.org/2000/svg\" transform=\"matrix(1, 0, 0, 1, 0, 0)\"><g id=\"SVGRepo_bgCarrier\" stroke-width=\"0\"></g><g id=\"SVGRepo_tracerCarrier\" stroke-linecap=\"round\" stroke-linejoin=\"round\"></g><g id=\"SVGRepo_iconCarrier\"><path d=\"M304 32H16A16 16 0 0 0 0 48v96a16 16 0 0 0 16 16h32a16 16 0 0 0 16-16v-32h56v304H80a16 16 0 0 0-16 16v32a16 16 0 0 0 16 16h160a16 16 0 0 0 16-16v-32a16 16 0 0 0-16-16h-40V112h56v32a16 16 0 0 0 16 16h32a16 16 0 0 0 16-16V48a16 16 0 0 0-16-16zm256 336h-48V144h48c14.31 0 21.33-17.31 11.31-27.31l-80-80a16 16 0 0 0-22.62 0l-80 80C379.36 126 384.36 144 400 144h48v224h-48c-14.31 0-21.32 17.31-11.31 27.31l80 80a16 16 0 0 0 22.62 0l80-80C580.64 386 575.64 368 560 368z\"></path></g></svg>",
	    	  picture: "<svg version=\"1.1\" id=\"_x32_\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" width=\"14px\" height=\"20px\" viewBox=\"0 0 512 512\" xml:space=\"preserve\" fill=\"#000000\"><g id=\"SVGRepo_bgCarrier\" stroke-width=\"0\"></g><g id=\"SVGRepo_tracerCarrier\" stroke-linecap=\"round\" stroke-linejoin=\"round\"></g><g id=\"SVGRepo_iconCarrier\"> <style type=\"text/css\">  .st0{fill:#000000;}  </style> <g> <path class=\"st0\" d=\"M99.281,399.469h320.094c6.172,0,11.844-3.422,14.719-8.875c2.844-5.469,2.438-12.078-1.063-17.141 l-69.156-100.094c-6.313-9.125-16.781-14.516-27.906-14.297s-21.406,5.969-27.375,15.359l-19.719,30.984l-54.828-79.359 c-6.313-9.172-16.797-14.531-27.922-14.328s-21.406,5.969-27.375,15.359L85.281,373.984c-3.25,5.109-3.469,11.578-0.531,16.875 C87.656,396.172,93.219,399.469,99.281,399.469z\"></path> <path class=\"st0\" d=\"M322.672,223.906c23.688,0,42.922-19.219,42.922-42.922c0-23.688-19.234-42.906-42.922-42.906 c-23.703,0-42.922,19.219-42.922,42.906C279.75,204.688,298.969,223.906,322.672,223.906z\"></path> <path class=\"st0\" d=\"M0,19.703v472.594h512v-25.313V19.703H0z M461.375,441.672H50.625V70.328h410.75V441.672z\"></path> </g> </g></svg>"
	      }, 
	      disableDragAndDrop: true,
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
		$('#summernote').summernote('pasteHTML', `${board.boardContent}`);
	    
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
					boardFileJsonArray.push(result);
					$(editor).summernote('insertImage', result["url"]);
				},
				error : function(e) {
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
	 
	   /*  
	    $('.note-editable').click(function() {
			
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
			
		}); // 글자 수 event 끝.
	
	    
	    
		$('#updateBtn').click(function(e) {
			e.preventDefault();
			
			const bno = '${ board.boardNo }';
			const no = '${board.boardCategoryNo}';
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
	             
	             for(let i = 0; i<boardFileJsonArray.length; i++){
	                let str = boardFileJsonArray[i].url;
	                // str의 값 : /board/summernoteImage/152210d9-a713-43ff-b81c-d9f1a3de0303(BN_CN10).jpg 
	                // '='를 기준으로 자른다.
	                let result = str.split('/');
	
	                const $input = document.createElement('input');
	                $input.setAttribute('name', 'filename');
	                $input.setAttribute('type', 'hidden');
	                $input.setAttribute('value', result[3]);
	
	                document.getElementById('modifyForm').appendChild($input);
	                
	             }  
				$('#modifyForm').submit();
			}
				
		}); //수정 버튼 이벤트 처리 끝.

		
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
		});

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

<script>
 const $color_button1 = document.querySelector('#summernote');
 console.log($color_button1);
 const $color_button2 = document.querySelector('.boardContent-summernote');
 console.log($color_button2);
 const $color_button3 = document.querySelector('.note-editor');
 console.log($color_button3);
 
 /* const $color_button1 = document.querySelector('button[class=note-btn note-current-color-button]');
 console.log($color_button1);
 const $color_button2 = document.querySelector('button[aria-label=Recent Color]');
 console.log($color_button2); */
</script>