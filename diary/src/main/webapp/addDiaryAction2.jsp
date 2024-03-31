<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>

<%
System.out.println("------addDiaryAction2.jsp");

//세션 로그인

String loginMember = (String)(session.getAttribute("loginMember"));
if(loginMember == null) {
	String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
	response.sendRedirect("/diary/loginForm2.jsp?errMsg="+errMsg);
	return;
}

Class.forName("org.mariadb.jdbc.Driver");

String memberId = request.getParameter("memberId");
System.out.println("memberID : " + memberId);

String sql = "select my_session from login";

Connection conn = null;

PreparedStatement stmt = null;
ResultSet rs = null;


conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

stmt = conn.prepareStatement(sql);
rs = stmt.executeQuery();

String mySession = null;
if (rs.next()) {
	mySession = rs.getString("my_session");

}

if (mySession.equals("OFF")) {
	String errMsg = "비정상적인 접근입니다. 로그인 해주세요.";
	System.out.println("비정상적인 접근입니다. 로그인 해주세요.");
//	response.sendRedirect("/diary/loginForm2.jsp");
	return;
}

String diaryDate = request.getParameter("diaryDate");
String title = request.getParameter("title");
String weather = request.getParameter("weather");
String content = request.getParameter("content");

System.out.println("diaryDate : " + diaryDate);
System.out.println("title : " + title);
System.out.println("weather : " + weather);
System.out.println("content : " + content);
//다이어리 입력 인서트 쿼리
String sql2 = "insert into diary(diary_date, title, weather, content, update_date, create_date) values(? ,? ,? ,? ,now() ,now())";

PreparedStatement stmt2 = null;
stmt2 = conn.prepareStatement(sql2);
stmt2.setString(1, diaryDate);
stmt2.setString(2, title);
stmt2.setString(3, weather);
stmt2.setString(4, content);

int row = stmt2.executeUpdate();

String msg = null;
if (row == 1) {
	System.out.println("다이어리 입력이 추가되었습니다.");
	msg = "다이어리 입력이 추가되었습니다.";
	response.sendRedirect("/diary/addDiaryForm2.jsp?memberId=" + memberId);
} else {
	System.out.println("다이어리 입력에 실패했습니다.");
	msg = "다이어리 입력에 실패했습니다.";
	response.sendRedirect("/diary/addDiaryForm2.jsp");
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