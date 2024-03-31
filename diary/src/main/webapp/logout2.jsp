<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>

<%
System.out.println("-----logout2.jsp");

String sessionId = session.getId();
System.out.println(sessionId);
session.invalidate(); //세션 종료
response.sendRedirect("/diary/loginForm2.jsp");
 //db방식 로그인 제어
Class.forName("org.mariadb.jdbc.Driver");


 //String sql = "select my_session from login";

Connection conn = null;

//PreparedStatement stmt = null;
//ResultSet rs = null;

conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

/*
stmt = conn.prepareStatement(sql);
rs = stmt.executeQuery();

String mySession = null;
if (rs.next()) {
	mySession = rs.getString("my_session");
}
if (mySession.equals("OFF")) {
	System.out.println("잘못된 접근입니다. 로그인해주세요");
	String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인해주세요", "utf-8");
	response.sendRedirect("/diary/loginForm2.jsp?errMsg=" + errMsg);
	return;
}
*/
//로그아웃 실행 my_session OFF으로 업데이트 쿼리
String sql2 = "update login set my_session = 'OFF', off_date = now() where my_session = 'ON'";

PreparedStatement stmt2 = null;
stmt2 = conn.prepareStatement(sql2);
int row = stmt2.executeUpdate();

if (row == 1) {
	System.out.println("로그아웃 성공");
	//response.sendRedirect("/diary/loginForm2.jsp");
	//return;
}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>logout2</title>
</head>
<body>

</body>
</html>