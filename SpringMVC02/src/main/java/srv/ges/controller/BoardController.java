package srv.ges.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import srv.ges.entity.Board;
import srv.ges.mapper.BoardMapper;

@Controller
public class BoardController {
	
	@Autowired
	BoardMapper boardMapper;
	
	@RequestMapping("/")
	public String main() {
		
		return "template";
	}
	
	@RequestMapping("/boardList.do")
	public @ResponseBody List<Board> boardList(){
		List<Board> list = boardMapper.getLists();
		
		return list;
	}
	
	@RequestMapping("/boardInsert.do")
	public @ResponseBody void boardInsert(Board vo) {
		boardMapper.boardInsert(vo);
	}
	
	@RequestMapping("/boardDelete.do")
	public @ResponseBody void boardDelete(int idx) {
		boardMapper.boardDelete(idx);
	}	
	
	@RequestMapping("/boardUpdate.do")
	public @ResponseBody void boardUpdate(Board vo) {
		boardMapper.boardUpdate(vo);
	}
	
	
	@RequestMapping("/boardContent.do")
	public @ResponseBody Board boardContent(int idx) {
		Board vo = boardMapper.boardContent(idx);
		
		return vo;
	}
	
	@RequestMapping("/boardCount.do")
	public @ResponseBody Board boardCount(int idx) {
		boardMapper.boardCount(idx);
		Board vo = boardMapper.boardContent(idx);
		
		return vo;
	}
}







