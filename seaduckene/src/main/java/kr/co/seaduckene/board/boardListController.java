package kr.co.seaduckene.board;


import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.WebUtils;

import com.google.gson.JsonObject;

import kr.co.seaduckene.board.command.BoardListVO;
import kr.co.seaduckene.board.command.BoardVO;
import kr.co.seaduckene.board.service.IBoardService;
import kr.co.seaduckene.common.NoticeVO;
import kr.co.seaduckene.user.command.UserVO;
import kr.co.seaduckene.user.service.IUserService;
import kr.co.seaduckene.util.PageVO;
import kr.co.seaduckene.util.SummernoteCopy;
import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/board")
public class boardListController {
	
	@Autowired
	private IBoardService boardService;
	
	@Autowired
	private IUserService userService;
	
	// summernote로 이미지 파일 복사하는 기능이 있는 클래스
	@Autowired
	private SummernoteCopy summernoteCopy;

	//게시판 목록으로 이동
	@GetMapping("/boardList/{categoryNo}")
	public String boardList(Model model, @PathVariable int categoryNo) {

		// a태그 달때 ? 프로덕트 넘버 달아서 넘기기 GET
		System.out.println("게시판 목록으로 이동!");
		model.addAttribute("categoryNo", categoryNo);
		model.addAttribute("productList", boardService.proList(categoryNo));
		model.addAttribute("category",boardService.getCategory(categoryNo));
		model.addAttribute("total", boardService.getTotal(categoryNo));
		
		return "board/boardList";
	}
	
	//페이징
	@GetMapping("/boardLists")
	@ResponseBody
	public List<BoardListVO> boardList(PageVO paging, int categoryNo) {
		
		paging.setCpp(9);
		
		return boardService.list(paging,categoryNo);
	}
	
	//글쓰기 페이지로 이동 요청
	@GetMapping("/boardWrite/{categoryNo}")
	public String boardWrite(@PathVariable int categoryNo, Model model, HttpSession session) {
		System.out.println("/board/boardWrite: GET");
		model.addAttribute("categoryNo", categoryNo);
		model.addAttribute("category",boardService.getCategory(categoryNo));
		
		int userNo = ((UserVO) session.getAttribute("login")).getUserNo();
		UserVO userVo = userService.getUserVoWithNo(userNo);
		model.addAttribute("nickName", userVo.getUserNickname());
		
		return "board/boardWrite";
	}
	// TODO Auto-generated catch block
	//게시글을 DB 등록 요청
	@PostMapping("/boardWrite")
	public String boardWrite(BoardVO boardVo, @RequestParam(value="filename", required=false) List<String> summerfileNames,
			MultipartFile thumbnail) {
		log.info("글 등록 요청이 들어옴!");
		log.info("vo: " + boardVo);
		
		boardService.write(boardVo);
		int boardNo = boardService.boardNoSearch(boardVo.getBoardUserNo());
		boardVo.setBoardContent(boardVo.getBoardContent().replaceAll("-_-_-", Integer.toString(boardNo)));
		boardVo.setBoardNo(boardNo);
		
		if (summerfileNames != null) {
			log.info("summerfileNames: " + summerfileNames);
			
			List<String> summerfileBnNames = new ArrayList<String>();
			
			for (String summerfileName : summerfileNames) {
				String summerfileBnName = summerfileName.replaceAll("-_-_-", Integer.toString(boardNo));
				summerfileBnNames.add(summerfileBnName);
				
				boardService.boardImageAdd(boardNo, summerfileBnName);
			}
			
			try {
				summerfileUpload(boardVo, summerfileNames, summerfileBnNames);
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		}
		
		if (thumbnail.getSize() != 0) {
			String uuid = UUID.randomUUID().toString().replaceAll("-", "");
			String fileRealName = thumbnail.getOriginalFilename();
			String fileExtension = fileRealName.substring(fileRealName.lastIndexOf("."), fileRealName.length());
			String boardThumbnailPath = "/ejsage3217/imgduck/board/";
			
			boardVo.setBoardThumbnailPath(boardThumbnailPath);
			boardVo.setBoardThumbnailFileName(uuid + fileExtension);
			boardVo.setBoardThumbnailFileRealName(fileRealName);
			
			// 나중에 날짜로 폴더명 구분할 때 사용함.
			/*File folder = new File(boardThumbnailPath);
			if(!folder.exists()) {
				folder.mkdirs();
			}*/
			File saveFile = new File(boardThumbnailPath + uuid + fileExtension);
			try {
				thumbnail.transferTo(saveFile);
			} catch (IllegalStateException | IOException e) {
				e.printStackTrace();
			}
		}
		
		boardService.update(boardVo);
		return "redirect:/board/boardList/" + boardVo.getBoardCategoryNo();
	}
	
	private void summerfileUpload(BoardVO boardVo, List<String> summerfileNames, List<String> summerfileBnNames) throws Exception {
		String boardContent;
		boardContent = boardVo.getBoardContent();
		String imgEditedContent = boardContent.replaceAll("summernoteImage", "getImg");
		boardVo.setBoardContent(imgEditedContent);
		
		// temp 폴더에서 board폴더로 파일을 복사하고 기존 temp의 파일을 삭제해준다.
		summernoteCopy.summerCopy(summerfileNames, summerfileBnNames, boardVo.getBoardNo());
		

	}
	
	//상세보기 페이지
	@GetMapping("/boardDetail/{boardNo}")
	public String boardDetail(@PathVariable int boardNo, PageVO pageVo, Model model, 
							HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		System.out.println("boardNo" + boardNo);
		
		int userNo;
		if(session.getAttribute("login") != null) {
			UserVO userVo = (UserVO) session.getAttribute("login");
			userNo = userVo.getUserNo();
			userVo = userService.getUserVoWithNo(userNo);
			model.addAttribute("loginUser", userVo);
		} else {
			userNo = 0;
		}
		System.out.println("최종 userNo: " + userNo);
		
		Cookie countView = WebUtils.getCookie(request, "countView" + userNo);
		if(countView==null) {
			System.out.println("countView 없음");
			Cookie newCookie = new Cookie("countView"+userNo, "bNo"+boardNo);
			newCookie.setMaxAge(60*60*2); // 두시간
			response.addCookie(newCookie);
			boardService.addViewCount(boardNo);
		} else {
			System.out.println("countView 있지롱");
			
			String value = countView.getValue();
			String[] bNoArray = value.split("bNo");
			List<String> bNoList = new ArrayList<String>(Arrays.asList(bNoArray)); 
			System.out.println("쿠키에 저장된 글번호 리스트:" + bNoList);
			System.out.println("가져온 value:" + value);
			if(!bNoList.contains(Integer.toString(boardNo))) {
				Cookie newCookie = new Cookie("countView"+userNo, value + "bNo"+boardNo);
				newCookie.setMaxAge(60*60*2); // 두시간
				response.addCookie(newCookie);
				boardService.addViewCount(boardNo);
			}
		}

		/*
		 * model.addAttribute("list", service.content(boardNo));
		 */
	
		BoardVO boardVo = boardService.getBoardDetailVo(boardNo);
		int categoryNo = boardVo.getBoardCategoryNo();

		model.addAttribute("category",boardService.getCategory(categoryNo));
		model.addAttribute("board", boardVo);
		
		UserVO boardUserVo = userService.getUserVoWithNo(boardVo.getBoardUserNo());
		model.addAttribute("nickName", boardUserVo.getUserNickname());
		
		return "board/boardDetail";
	}
	
	//수정 페이지로 이동
	@PostMapping("/boardModify")
	public void modify(@ModelAttribute("board") BoardVO boardVo, Model model, HttpSession session) {
		log.info(boardVo);
		int categoryNo = boardVo.getBoardCategoryNo();
		model.addAttribute("category", boardService.getCategory(categoryNo));
		
		int userNo = ((UserVO) session.getAttribute("login")).getUserNo();
		UserVO userVo = userService.getUserVoWithNo(userNo);
		
		model.addAttribute("nickName", userVo.getUserNickname());
	}
	
	/** 
	 * // TODO Auto-generated catch block
	 * */
	//글 수정 처리
	@PostMapping("/boardUpdate")
	public String boardUpdate(BoardVO updatedBoardVo, @RequestParam(value="filename", required=false) List<String> summerfileNames, MultipartFile thumbnail) {
		log.info(updatedBoardVo);
		log.info("글 수정 요청이 들어옴!");

		int boardNo = updatedBoardVo.getBoardNo();
		updatedBoardVo.setBoardContent(updatedBoardVo.getBoardContent().replaceAll("-_-_-", Integer.toString(boardNo)));
		
		BoardVO previousBoardVo = boardService.getBoardDetailVo(boardNo);
		
		updatedBoardVo.setBoardThumbnailPath(previousBoardVo.getBoardThumbnailPath());
		updatedBoardVo.setBoardThumbnailFolder(previousBoardVo.getBoardThumbnailFolder());
		updatedBoardVo.setBoardThumbnailFileName(previousBoardVo.getBoardThumbnailFileName());
		updatedBoardVo.setBoardThumbnailFileRealName(previousBoardVo.getBoardThumbnailFileRealName());
		
		if (summerfileNames != null) {
			log.info("summerfileNames: " + summerfileNames);
			
			List<String> summerfileBnNames = new ArrayList<String>();
			
			for (String summerfileName : summerfileNames) {
				String summerfileBnName = summerfileName.replaceAll("-_-_-", Integer.toString(boardNo));
				summerfileBnNames.add(summerfileBnName);
				
				boardService.boardImageAdd(boardNo, summerfileBnName);
			}
			
			try {
				summerfileUpload(updatedBoardVo, summerfileNames, summerfileBnNames);
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		}
		
		if (thumbnail.getSize() != 0) {
			String uuid = UUID.randomUUID().toString().replaceAll("-", "");
			String fileRealName = thumbnail.getOriginalFilename();
			String fileExtension = fileRealName.substring(fileRealName.lastIndexOf("."), fileRealName.length());
			String boardThumbnailPath = "/ejsage3217/imgduck/board/";
			
			updatedBoardVo.setBoardThumbnailPath(boardThumbnailPath);
			updatedBoardVo.setBoardThumbnailFileName(uuid + fileExtension);
			updatedBoardVo.setBoardThumbnailFileRealName(fileRealName);
			
			// 나중에 날짜로 폴더명 구분할 때 사용함.
			/*File folder = new File(boardThumbnailPath);
			if(!folder.exists()) {
				folder.mkdirs();
			}*/
			File saveFile = new File(boardThumbnailPath + uuid + fileExtension);
			try {
				thumbnail.transferTo(saveFile);
			} catch (IllegalStateException | IOException e) {
				e.printStackTrace();
			}
			
			// 이전 썸네일 파일 지우는 코드
		    File previousThumbnailFile = new File(previousBoardVo.getBoardThumbnailPath() +
//				previousBoardVo.getBoardThumbnailFolder() + "/" +
			    previousBoardVo.getBoardThumbnailFileName());
		
		    previousThumbnailFile.delete();
			  
			 
		}
		
		boardService.update(updatedBoardVo);
		return "redirect:/board/boardDetail/" + boardNo;
	}
	
	//글 삭제 처리
	@PostMapping("/boardDelete")
	public String boardDelete(int boardNo, int boardCategoryNo) {
		boardService.delete(boardNo);
		
		return "redirect:/board/boardList/" + boardCategoryNo;
	}
	
	// 공지사항 리스트
	@GetMapping("/noticeList")
	@ResponseBody
	public List<NoticeVO> noticeList() {
		System.out.println("noticeList :" + boardService.noticeList() );
		return boardService.noticeList();
	}
	
	// 공지사항페이지 이동
	@GetMapping("/notice")
	public void notice(Model model) {
		model.addAttribute("total", boardService.getNoticeTotal());
	}
	
	// 공지사항 페이징
	@GetMapping("/noticeLists")
	@ResponseBody
	public List<NoticeVO> noticeLists(PageVO paging) {
		
		paging.setCpp(10);
		System.out.println("noticeLists :" + boardService.noticeLists(paging) );
		return boardService.noticeLists(paging);
	}
	
	@PostMapping(value="/uploadSummernoteImageFile", produces = "application/json")
	@ResponseBody
	public String uploadSummernoteImageFile(@RequestParam("file") MultipartFile multipartFile,
										String categoryNo) {
		log.info("uploadSummernoteImageFile POST : " + multipartFile);
		log.info("categoryNo : " + categoryNo);
		
		JsonObject jsonObject = new JsonObject();
		
		String fileRoot = "/ejsage3217/imgduck/temp/";	//저장될 외부 파일 경로
		String originalFileName = multipartFile.getOriginalFilename();	//오리지날 파일명
		String extension = originalFileName.substring(originalFileName.lastIndexOf("."));	//파일 확장자 
				
		categoryNo = categoryNo.length() == 1 ? "0" + categoryNo : categoryNo;
		
		String uuid = UUID.randomUUID().toString().replaceAll("-", "");
		String savedFileName = uuid + "(BN-_-_-CN" + categoryNo + ")" + extension;	//저장될 파일명
		
		File targetFile = new File(fileRoot + savedFileName);	
		
		try { 
			InputStream fileStream = multipartFile.getInputStream();
			FileUtils.copyInputStreamToFile(fileStream, targetFile);	//파일 저장
			jsonObject.addProperty("url", "/board/summernoteImage/"+savedFileName);
			jsonObject.addProperty("responseCode", "success");
				
		} catch (IOException e) {
			FileUtils.deleteQuietly(targetFile);	//저장된 파일 삭제
			jsonObject.addProperty("responseCode", "error");
			e.printStackTrace();
		}
		
		String str = jsonObject.toString();
		System.out.println("변환된 json 데이터: " + str);
		
		return str;
	}
	
	
	@GetMapping("/summernoteImage/{savedFileName}")
	@ResponseBody
	public ResponseEntity<byte[]> getImg(@PathVariable String savedFileName, HttpServletRequest request, HttpServletResponse response) {
		String reqUri = request.getRequestURI();
		System.out.println("요청 URI: " + reqUri);
		System.out.println("미리보기 이미지 요청 호출!");
		System.out.println("param: " + savedFileName);
		String fileRoot = "/ejsage3217/imgduck/temp/";
		String filePath = fileRoot + savedFileName;
		System.out.println("완성된 파일 경로: " + filePath);
		File file = new File(filePath);
		
		ResponseEntity<byte[]> result = null;
		HttpHeaders headers = new HttpHeaders();
		
		try {
			headers.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<byte[]>(FileCopyUtils.copyToByteArray(file), headers, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
		
	}

	@GetMapping("/getImg/{savedFileName}")
	public ResponseEntity<byte[]> getImgCopy(@PathVariable String savedFileName, HttpServletResponse response){
	  
	  String fileRoot = "/ejsage3217/imgduck/board/";
	  String filePath = fileRoot + savedFileName; 
	  File file = new File(filePath);
		
		ResponseEntity<byte[]> result = null;
		HttpHeaders headers = new HttpHeaders();
		
		try {
			headers.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<byte[]>(FileCopyUtils.copyToByteArray(file), headers, HttpStatus.OK);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	//임시파일 삭제 요청
	@PostMapping("/tempDelete")
	@ResponseBody
	public void tempDelete(@RequestBody List<String> list) {
		System.out.println("임시 파일 삭제 요청!");
		System.out.println("deleteFiles: " + list);
		
		for(String fileName : list) {
			String tempRoot = "/ejsage3217/imgduck/temp/";
			File file = new File(tempRoot + fileName);
			if(file.exists()) {
				System.out.println("임시 파일 삭제 완료!");
				file.delete();
			}
			
		}	
	}
	@GetMapping("boardMyList")
	@ResponseBody
	public List<BoardVO> myList(PageVO paging, HttpSession session) {
		log.info("GET boardMyList 요청");
		int userNo = ((UserVO)session.getAttribute("login")).getUserNo();
		Map<String, Object> data = new HashMap<String, Object>();
		paging.setCpp(20);
		data.put("paging", paging);
		data.put("userNo", userNo);
		List<BoardVO> list= boardService.getMyList(data);
		
		System.out.println("가져온 리스트:"+list);
		
		return list;
	}

}