package kr.co.seaduckene.util.interceptor;

import java.sql.Timestamp;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.HandlerInterceptor;

import kr.co.seaduckene.common.CategoryVO;
import kr.co.seaduckene.product.service.IProductService;
import kr.co.seaduckene.user.command.UserVO;
import kr.co.seaduckene.user.service.IUserService;
import kr.co.seaduckene.user.service.KakaoLoginService;
import lombok.extern.log4j.Log4j;

@Log4j
public class CategoryHandler implements HandlerInterceptor {
	
	@Autowired
	private IUserService userService;
	
	@Autowired
	private IProductService productService;
	
	@Autowired
	private KakaoLoginService KKLService;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		System.out.println("Action CategoryHandler");
		
		
		List<String> majorList = productService.getMajor();	
		//model.addAttribute("majorList", majorList);
		request.setAttribute("majorListHeader", majorList);
		
		List<CategoryVO> categoryList = productService.getCategory();
		//model.addAttribute("categoryList" , categoryList);
		request.setAttribute("ctListHeader" , categoryList);
		
		request.setAttribute("KakaoLogout", KKLService.getKakaoLogoutUrl());
		
		HttpSession session = request.getSession();
		
		// kakao access_token 만료 여부 확인 코드
		if (session.getAttribute("kakao") != null) {
			
			int userNo = (Integer) ((UserVO) session.getAttribute("login")).getUserNo();
			
			UserVO userVo = userService.getUserVoWithNo(userNo);
			
			long loginTokenRegDate = userVo.getUserKakaoRegDate().getTime();
			
			long currenTimeMillis = System.currentTimeMillis();
			
			boolean expriedKakaoToken  = (currenTimeMillis - loginTokenRegDate) >= 21599;
			log.info("expriedKakaoToken: " + expriedKakaoToken);
			
			if (expriedKakaoToken) {
				session.removeAttribute("kakao");
				session.removeAttribute("login");
			}
			
		} else if(session.getAttribute("naver") != null) {
			
			int userNo = (Integer) ((UserVO) session.getAttribute("login")).getUserNo();
			
			UserVO userVo = userService.getUserVoWithNo(userNo);
			
			long loginTokenRegDate = userVo.getUserNaverRegDate().getTime();
			
			long currenTimeMillis = System.currentTimeMillis();
			
			boolean expriedKakaoToken  = (currenTimeMillis - loginTokenRegDate) >= 3600;
			log.info("expriedKakaoToken: " + expriedKakaoToken);
			
			if (expriedKakaoToken) {
				session.removeAttribute("naver");
				session.removeAttribute("login");
			}
			
		}
		
		return true;
	}

}
