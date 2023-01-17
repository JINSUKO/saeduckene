package kr.co.seaduckene.admin.mapper;

import java.util.List;

import kr.co.seaduckene.admin.command.AdminSearchVO;
import kr.co.seaduckene.admin.command.AdminVO;
import kr.co.seaduckene.common.NoticeVO;

public interface IAdminMapper {

	// 관리자 정보 가져오기
	AdminVO getAdminVo(AdminVO adminVO);
	
	// 공지사항 글 쓰기
	void write(NoticeVO noticeVO);
	
	// 모든 주문 확인
	List<AdminSearchVO> allOrder();
	
	// 유저 정보 검색
	List<AdminSearchVO> usersSearch(String search);
}
