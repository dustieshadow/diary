<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>

<%
	System.out.println("---------modifyDiaryAction2.jsp");
	String diaryDate = request.getParameter("diaryDate");
	String memberId = request.getParameter("diaryDate");
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	String weather = request.getParameter("weather");
	
	System.out.println("diaryDate : "+diaryDate);
	System.out.println("memberId : "+memberId);
	
	System.out.println("title : "+title);
	System.out.println("weather : "+weather);
	System.out.println("content : "+content );
	
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
	//다이어리 수정변경 - 업데이트 쿼리
	String sql2 = "update diary set title=?, weather=?, content=?, update_date=now() where diary_date = ? ";
	
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,title);
	stmt2.setString(2,weather);
	stmt2.setString(3,content);
	stmt2.setString(4,diaryDate);
	
	int row = stmt2.executeUpdate();
	
	String msg= null;
	if(row==1){
		System.out.println("업데이트에 성공했습니다.");
		msg = URLEncoder.encode("업데이트에 성공했습니다.","utf-8");
		response.sendRedirect("/diary/modifyDiaryForm2.jsp?diaryDate="+diaryDate+"&msg="+msg);
	}else{
		System.out.println("업데이트에 실패했습니다.");;
		msg =URLEncoder.encode("업데이트에 실패했습니다.","utf-8");
		response.sendRedirect("/diary/modifyDiaryForm2.jsp?diaryDate="+diaryDate+"&msg="+msg);
	}
	
	

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>