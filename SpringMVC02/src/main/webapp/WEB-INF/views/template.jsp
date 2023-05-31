<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>   
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
	$(document).ready(function(){
		loadList();
	});
	
	function loadList(){
		// 서버와 통신 : 게시판 List 가져오기
		$.ajax({
			url : "boardList.do",
			type : "get",
			dataType : "json",
			success : makeView,
			error : function(){ alert("error"); }
		});
	}
	
	function makeView(data){	// JSON data = [{ Board } { Board } { Board }]
		let listHtml ="<table class='table table-bordered'>";
		listHtml+="<tr>";
		listHtml+="<td>번호</td>";
		listHtml+="<td>제목</td>";
		listHtml+="<td>작성자</td>";
		listHtml+="<td>작성일</td>";
		listHtml+="<td>조회수</td>";
		listHtml+="</tr>";
		data.forEach((element) => {
			listHtml+="<tr>";
			listHtml+="<td>"+element.idx+"</td>";
			listHtml+="<td id='t"+element.idx+"'><a href='javascript:goContent("+element.idx+")'>"+element.title+"</a></td>";
			listHtml+="<td>"+element.writer+"</td>";
			listHtml+="<td>"+element.indate.split(' ')[0]+"</td>";
			listHtml+="<td id='cnt"+element.idx+"'>"+element.count+"</td>";
			listHtml+="</tr>";
			
			listHtml+="<tr id='c"+element.idx+"' style='display:none'>";
			listHtml+="<td>내용</td>";
			listHtml+="<td colspan='5'>";
			listHtml+="<textarea rows='7' class='form-control' id='ta"+element.idx+"' readonly='readonly'></textarea>";
			listHtml+="</br>";
			listHtml+="<span id='up"+element.idx+"'><button class='btn btn-dark btn-sm' onclick='goUpdateForm("+element.idx+")'>수정화면</button></span>&nbsp;";
			listHtml+="<button class='btn btn-danger btn-sm' onclick='goDelete("+element.idx+")'>삭제</button>";
			listHtml+="</td>";
			listHtml+="</tr>";
		});
		listHtml+="<tr>";
		listHtml+="<td colspan='5'>";
		listHtml+="<button class='btn btn-dark btn-sm' onclick='goForm()'>Write</button>";
		listHtml+="</td>";
		listHtml+="</tr>";
		listHtml+="</table>"
		$('#view').html(listHtml);
	}
	
	function goForm(){
		$('#view').css("display","none");
		$('#writeForm').css("display","block");	
	}
	
	function goList(){
		$('#view').css("display","block");
		$('#writeForm').css("display","none");	
	}
	
	function goInsert(){
// 		const title = $('#title').val();
// 		const content = $('#content').val();
// 		const writer = $('#writer').val();
		
		const fData = $('#frm').serialize();	//직렬화
		$.ajax({
			url : "boardInsert.do",
			type : "post",
			data : fData,
			success : loadList,
			error : function(){ alert("error"); }
		});
		// 폼 초기화
// 		$('#title').val("")
// 		$('#content').val("");
// 		$('#writer').val("");
		$('#cancel').trigger("click");
		
		goList();
	}
	
	function goContent(idx){
		if($('#c'+idx).css("display") == 'none'){
			
			$.ajax({
				url : "boardContent.do",
				type : "get",
				data : {"idx": idx},
				dataType : "json",
				success : function(data){	// data={ "content" : ~~ }
					$('#ta'+idx).val(data.content);
				},
				error : function(){ alert("error"); }
			});
			
			$('#c'+idx).css("display","table-row");
			$('#ta'+idx).attr('readonly', true);
		} else {
			$('#c'+idx).css("display","none");
			$.ajax({
				url : "boardCount.do",
				type : "get",
				data : {"idx" : idx},
				dataType : "json",
				success : function(data){
					$('#cnt'+idx).text(data.count);
				},
				error : function(){ alert("error"); }
				
			});
		}
	}
	
	function goDelete(idx){
		$.ajax({
			url : "boardDelete.do",
			type : "get",
			data : {"idx" : idx},
			success : loadList,
			error: function(){ alert("error"); }
			
		});
	}
	
	function goUpdateForm(idx){
		$('#ta'+idx).attr('readonly', false);
		let title = $('#t'+idx).text();
		
		let newInput="<input type='text' class='form-control' value='"+title+"' id='newInput"+idx+"' />";
		$('#t'+idx).html(newInput);
		
		let newButton = "<button class='btn btn-dark btn-sm' onclick='goUpdate("+idx+")'>Update</button>";
		$('#up'+idx).html(newButton);
		
	}
	
	function goUpdate(idx){
		const title = $('#newInput'+idx).val();
		const content = $('#ta'+idx).val();
		
		$.ajax({
			url : "boardUpdate.do",
			type : "post",
			data : {"idx" : idx, "title" : title, "content" : content },
			success : loadList,
			error : function(){ alert("error"); }
			
		});
	}
	
</script>
<title>Insert title here</title>
</head>
<body>

	<div class="container">
		<h2>Spring MVC 02</h2>
		<div class="card">
			<div class="card-header">Board</div>
			<div class="card-body" id="view">게시판 목록</div>
			<div class="card-body" style="display: none;" id="writeForm">
				<form id="frm">
					<table class="table">
						<tr>
							<td>제목</td>
							<td><input type="text" name="title" id="title" class="form-control" /></td>
						</tr>
						<tr>
							<td>내용</td>
							<td><textarea rows="7" name="content" id="content" class="form-control"></textarea></td>
						</tr>
						<tr>
							<td>작성자</td>
							<td><input type="text" name="writer" id="writer" class="form-control" /></td>
						</tr>
						<tr>
							<td colspan="2" align="center">
								<button type="button" class="btn btn-dark btn-sm" onclick="goInsert()">UPLOAD</button>
								<button type="reset" class="btn btn-danger btn-sm" id="cancel">Cancel</button>
								<button type="button" class="btn btn-primary btn-sm" onclick="goList()">List</button>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div class="card-footer">Inflearn_Spring MVC 02</div>
		</div>
	</div>

</body>
</html>