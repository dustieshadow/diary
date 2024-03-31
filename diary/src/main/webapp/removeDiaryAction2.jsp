<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>

<%
	System.out.println("---------removeDiaryAction2.jsp");
	String diaryDate = request.getParameter("diaryDate");
	String memberId = request.getParameter("diaryDate");

	
	System.out.println("diaryDate : "+diaryDate);
	System.out.println("memberId : "+memberId);

	
	Class.forName("org.mariadb.jdbc.Driver");
	
	String sql = "select my_session from login";
	
	Connection conn = null;
	
	String loginMember = (String)(session.getAttribute("loginMember"));
	if(loginMember == null) {
		String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
		response.sendRedirect("/diary/loginForm2.jsp?errMsg="+errMsg);
		return;
	}

	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	
	String mySession = null;
	
	if(rs.next()){
		mySession = rs.getString("my_session");
	}
	if(mySession.equals("OFF")){
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요.","utf-8");
		System.out.println("비정상접근");
//		response.sendRedirect("/diary/loginForm2.jsp");
		return;
	}
	//다이어리 삭제 쿼리 diary 테이블-diary_date 조건일치시
	String sql2 = "delete from diary where diary_date = ? ";
	
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, diaryDate);
	
	int row = stmt2.executeUpdate();
	
	String msg= null;
	if(row==1){
		System.out.println("삭제에 성공했습니다.");
		msg = URLEncoder.encode("삭제에 성공했습니다.","utf-8");
		response.sendRedirect("/diary/diaryOne2.jsp?diaryDate="+diaryDate+"&msg="+msg);
	}else{
		System.out.println("삭제에 실패했습니다.");;
		msg =URLEncoder.encode("삭제에 실패했습니다.","utf-8");
		response.sendRedirect("/diary/diaryOne2.jsp?diaryDate="+diaryDate+"&msg="+msg);
	}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>RemoveDiaryAction</title>
</head>
<body>
</body>
</html>