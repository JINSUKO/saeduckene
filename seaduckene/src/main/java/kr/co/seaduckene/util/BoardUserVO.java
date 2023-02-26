package kr.co.seaduckene.util;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

 /*
-- 내가 선택한 카테고리의 보더 
<![CDATA[
	SELECT * FROM
		(
			SELECT ROWNUM AS rn,tbl.* FROM
				(
					SELECT DISTINCT b.board_no, b.board_title, b.board_views, b.board_reg_date, c.category_no
									, c.category_major_title, c.category_minor_title, d.user_nickname
									, d.user_no, f.favorite_category_no, f.favorite_user_no
					FROM board b LEFT JOIN duck_user d ON b.board_user_no= d.user_no
								 LEFT JOIN category c ON b.board_category_no = c.category_no
								 LEFT JOIN favorite f ON c.category_no = f.favorite_category_no
					WHERE f.favorite_user_no= #{userNo}
                    ORDER BY b.board_views DESC, b.board_reg_date DESC
				) tbl
		)
	WHERE rn > 0  AND rn <= 9
]]>

-- 유저가 없을때 뷰가 가장 높은 카테고리의 보더
<![CDATA[
	SELECT * FROM
	    (
		    SELECT ROWNUM AS rn, tbl.* FROM
		        (
		            SELECT b.board_no, b.board_title, b.board_views, b.board_reg_date, c.category_major_title, c.category_minor_title, d.user_nickname
		            FROM board b LEFT JOIN category c ON b.board_category_no = c.category_no
		                         LEFT JOIN duck_user d ON b.board_user_no = d.user_no
		            ORDER BY b.board_views DESC, b.board_reg_date DESC
		        ) tbl
	    ) 
	WHERE rn > 0 AND rn <= 9
]]>
 */

@Getter
@Setter
@ToString
@NoArgsConstructor // 매개변수 없는 생성자
@AllArgsConstructor // 매개변수 다 있는 생성자
public class BoardUserVO {
	
	private int boardNo;
	private String boardTitle;
	private String boardContent;
	private int boardViews;
	private String categoryMinorTitle;
	private String userNickname;
	private int userNo;
	
}