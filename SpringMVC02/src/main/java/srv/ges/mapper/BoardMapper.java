package srv.ges.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;

import srv.ges.entity.Board;

@Mapper
public interface BoardMapper {
	
	public List<Board> getLists();			// 전체리스트 조회
	public void boardInsert(Board vo);		// 글 등록
	public Board boardContent(int idx);		// 글 상세보기
	public void boardDelete(int idx);		// 글 삭제하기
	public void boardUpdate(Board vo);		// 글 수정하기
	
	@Update("update myboard set count = count + 1 where idx = #{idx}")
	public void boardCount(int idx);		// 조회수 증가
}
