package kr.co.seaduckene.board.command;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

 /*
SELECT *
FROM
    (
    SELECT ROWNUM AS rn, tbl.* FROM
        (
        SELECT * 
        FROM board d
        INNER JOIN boardImage i
        ON d.board_no = i.board_board_no
        INNER JOIN category ｃ
        ON d.board_category_no = ｃ.category_no
        WHERE d.board_category_no = 1
        ORDER BY d.board_no DESC
        ) tbl
    )
WHERE rn > 0
AND rn <= 9
 */

@Getter
@Setter
@ToString
@NoArgsConstructor // 매개변수 없는 생성자
@AllArgsConstructor // 매개변수 다 있는 생성자
public class BoardListVO {
	
	private int boardNo;
	private String boardTitle;
	private String boardContent;
	private int boardViews;
	private String boardThumbnailFileName;
	private Timestamp boardRegDate;
	private Timestamp boardUpDate;
	private int boardUserNo;
	private int boardCategoryNo;
	private int categoryNo;
	private String categoryMajorTitle;
	private String categoryMinorTitle;
	private Timestamp categoryRegDate;

	private String writer;
	
}

 
 
 
 
 
 
 
 
 
 
 