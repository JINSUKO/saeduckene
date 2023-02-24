package kr.co.seaduckene.board.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.seaduckene.board.command.BoardListVO;
import kr.co.seaduckene.board.command.BoardVO;
import kr.co.seaduckene.board.mapper.IBoardMapper;
import kr.co.seaduckene.common.CategoryVO;
import kr.co.seaduckene.common.NoticeVO;
import kr.co.seaduckene.product.command.ProductVO;
import kr.co.seaduckene.util.BoardUserVO;
import kr.co.seaduckene.util.PageVO;

@Service
public class BoardServiceImpl implements IBoardService {

	@Autowired
	private IBoardMapper boardMapper;

	@Override
	public void write(BoardVO vo) {
		System.out.println("서비스 vo 들어옮" + vo);
		boardMapper.write(vo);
	}

	@Override
	public List<BoardListVO> list(PageVO paging, int categoryNo) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("paging", paging);
		map.put("categoryNo", categoryNo);

		return boardMapper.list(map);
	}
	
	@Override
	public int getTotal(int categoryNo) {
		return boardMapper.getTotal(categoryNo);
	}
	
	@Override
	public int getMyBoardTotal(int userNo) {
		return boardMapper.getMyBoardTotal(userNo);
	}

	@Override
	public CategoryVO getCategory(int categoryNo) {
		return boardMapper.getCategory(categoryNo);
	}
	
	@Override
	public int getNoticeTotal() {
		return boardMapper.getNoticeTotal();
	}

	@Override
	public BoardVO content(int bno) {
		return boardMapper.content(bno);
	}

	@Override
	public void update(BoardVO vo) {
		boardMapper.update(vo);

	}

	@Override
	public void delete(int bno) {
		boardMapper.delete(bno);

	}

	@Override
	public List<ProductVO> proList(int categoryNo) {
		return boardMapper.proList(categoryNo);
	}

	@Override
	public List<BoardUserVO> bUserList(int userNo) {
		return boardMapper.bUserList(userNo);
	}

	@Override
	public List<BoardUserVO> bUserNoList() {
		return boardMapper.bUserNoList();
	}

	@Override
	public List<NoticeVO> noticeList() {
		return boardMapper.noticeList();
	}

	@Override
	public List<NoticeVO> noticeLists(PageVO paging) {
		return boardMapper.noticeLists(paging);
	}

	@Override
	public int boardNoSearch(int boardUserNo) {
		return boardMapper.boardNoSearch(boardUserNo);
	}

	@Override
	public void boardImageAdd(int boardNo, String UUID) {
		boardMapper.boardImageAdd(boardNo, UUID);
	}

	@Override
	public void addViewCount(int boardNo) {
		boardMapper.addViewCount(boardNo);
	}

	@Override
	public List<BoardVO> getMyList(Map<String, Object> data) {
		return boardMapper.getMyList(data);
	}
	
}
