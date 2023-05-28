package srv.ges.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import srv.ges.entity.Board;
import srv.ges.mapper.BoardMapper;

@Controller
public class BoardController {
	
	@Autowired
	private BoardMapper boardMapper;

	@RequestMapping("/boardList.do")	// Handler Mapping
	public String boardList(Model model) {
		
		List<Board> list = boardMapper.getLists();
		model.addAttribute("list", list);
		
		return "boardList";
	}
	
	@GetMapping("/boardForm.do")
	public String boardForm() {
		
		return "boardForm";
	}
	
	@PostMapping("/boardInsert.do")
	public String boardInsert(Board vo) { // Parameter 수집 - title content writer -> form에서의 name과 Entity 필드명이 같아야 함
		
		boardMapper.boardInsert(vo);
		
		return "redirect:/boardList.do";
	}
	
	@GetMapping("/boardContent.do")
	public String boardContent(@RequestParam("idx") int idx, Model model) {
		
		Board vo = boardMapper.boardContent(idx);
		
		// 조회수 증가
		boardMapper.boardCount(idx);
		model.addAttribute("vo", vo);
		
		return "boardContent";
	}
	
	@GetMapping("/boardDelete.do")
	public String boardDelete(@RequestParam("idx") int idx) {
		
		boardMapper.boardDelete(idx);
		
		return "redirect:/boardList.do";
	}
	
	@GetMapping("/boardUpdateForm.do")
	public String boardUpdateForm(@RequestParam("idx") int idx, Model model) {
		
		Board vo = boardMapper.boardContent(idx);
		model.addAttribute("vo", vo);
		
		return "boardUpdate";
	}
	
	@PostMapping("boardUpdate.do")
	public String boardUpdate(Board vo) {	// idx, title, content
		
		boardMapper.boardUpdate(vo);
		
		return "redirect:/boardList.do";
	}
	
	
}







