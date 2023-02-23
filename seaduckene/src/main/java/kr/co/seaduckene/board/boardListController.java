package kr.co.seaduckene.board;


import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
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

import kr.co.seaduckene.board.command.BoardVO;
import kr.co.seaduckene.board.service.IBoardService;
import kr.co.seaduckene.common.NoticeVO;
import kr.co.seaduckene.user.command.UserVO;
import kr.co.seaduckene.util.PageVO;
import kr.co.seaduckene.util.summernoteCopy;
import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/board")
public class boardListController {
	
	@Autowired
	private IBoardService boardService;

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
	public List<BoardVO> boardList(PageVO paging, int categoryNo) {
		
		paging.setCpp(9);
		
		return boardService.list(paging,categoryNo);
	}
	
	//글쓰기 페이지로 이동 요청
	@GetMapping("/boardWrite/{categoryNo}")
	public String boardWrite(@PathVariable int categoryNo, Model model, HttpSession session) {
		System.out.println("/board/boardWrite: GET");
		model.addAttribute("categoryNo", categoryNo);
		model.addAttribute("category",boardService.getCategory(categoryNo));
		
		UserVO vo = (UserVO)session.getAttribute("login");
		model.addAttribute("nickName", vo.getUserNickname());
		
		return "board/boardWrite";
	}
	
	//게시글을 DB 등록 요청
	@PostMapping("/boardWrite")
	public String boardWrite(BoardVO vo, @RequestParam(value="filename", required=false) List<String> summerfiles,
			MultipartFile thumbnail) {
		log.info("글 등록 요청이 들어옴!");
		log.info("vo: " + vo);
		String boardNo = Integer.toString(boardService.getLatestBoardNo() + 1);
		vo.setBoardContent(vo.getBoardContent().replaceAll("_", boardNo));
		if(summerfiles != null) {
			log.info("summerFile: " + summerfiles);
			
			try {
				summerfileUpload(vo, summerfiles);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		boardService.write(vo);
		return "redirect:/board/boardList/" + vo.getBoardCategoryNo();
	}
	
	private void summerfileUpload(BoardVO vo, List<String> summerfiles) throws Exception {
		String boardContent;
		boardContent = vo.getBoardContent();
		String imgEditedContent = boardContent.replaceAll("summernoteImage", "getImg");
		vo.setBoardContent(imgEditedContent);
		
		summernoteCopy copy = new summernoteCopy();
		copy.summerCopy(summerfiles);
		
		int boardNo = boardService.boardNoSearch(vo.getBoardUserNo());
		for (String summerfile : summerfiles) {
			boardService.boardImageAdd(boardNo, summerfile);
		}
	}
	
	//상세보기 페이지
	@GetMapping("/boardDetail/{boardNo}")
	public String boardDetail(@PathVariable int boardNo, PageVO vo, Model model, 
							HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		System.out.println("boardNo" + boardNo);
		
		int userNo;
		if(session.getAttribute("login") != null) {
			UserVO userVo = (UserVO) session.getAttribute("login");
			userNo = userVo.getUserNo();
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
	
		BoardVO board = boardService.content(boardNo);
		int categoryNo = board.getBoardCategoryNo();

		model.addAttribute("category",boardService.getCategory(categoryNo));
		model.addAttribute("list", board);
		
		return "board/boardDetail";
	}
	
	//수정 페이지로 이동
	@PostMapping("/boardModify")
	public void modify(@ModelAttribute("list") BoardVO vo, Model model) {
		int categoryNo = vo.getBoardCategoryNo();
		model.addAttribute("category",boardService.getCategory(categoryNo));
		System.out.println(vo);
	}
	
	//글 수정 처리
	@PostMapping("/boardUpdate")
	public String boardUpdate(BoardVO vo) {
		System.out.println(vo);
		boardService.update(vo);
		return "redirect:/board/boardDetail/" + vo.getBoardNo();
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
		
		String fileRoot = "c:/imgduck/temp/";	//저장될 외부 파일 경로
		String originalFileName = multipartFile.getOriginalFilename();	//오리지날 파일명
		String extension = originalFileName.substring(originalFileName.lastIndexOf("."));	//파일 확장자 
				
		categoryNo = categoryNo.length() == 1 ? "0" + categoryNo : categoryNo;
		
		String savedFileName = UUID.randomUUID() + "(BN_CN" + categoryNo + ")" + extension;	//저장될 파일명
		
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
		String fileRoot = "c:/imgduck/temp/";
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
	  
	  String fileRoot = "c:/imgduck/board/";
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
	public void tempDelete(@RequestBody List<String> list) {
		System.out.println("임시 파일 삭제 요청!");
		System.out.println("deleteFiles: " + list);
		
		for(String fileName : list) {
			String tempRoot = "c:/imgduck/temp/";
			File file = new File(tempRoot + fileName);
			if(file.exists()) {
				System.out.println("임시 파일 삭제 완료!");
				file.delete();
			}
			
		}	
	}
	@GetMapping("boardMyList")
	@ResponseBody
	public List<BoardVO> myList(int pageNum,HttpSession session) {
		System.out.println("GET boardMyList 요청");
		int userNo = ((UserVO)session.getAttribute("login")).getUserNo();
		Map<String, Object> data = new HashMap<String, Object>();
		PageVO paging = new PageVO();
		paging.setPageNum(pageNum);
		data.put("page", paging);
		data.put("userNo", userNo);
		List<BoardVO> list= boardService.getMyList(data);
		
		System.out.println("가져온 리스트:"+list);
		
		return list;
	}

}