package kr.co.seaduckene;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/board")
public class BoardController {
	
	//상세보기
	@GetMapping("/detail")
	public void detail() {}

}
