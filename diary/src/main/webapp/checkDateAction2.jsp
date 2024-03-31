<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>

<%
System.out.println("------checkDateAction2.jsp");

String checkDate = request.getParameter("checkDate");

System.out.println("checkDate = " + checkDate);

Class.forName("org.mariadb.jdbc.Driver");

String sql = "select my_session from login ";

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
String errMsg = null;
if (rs.next()) {
	mySession = rs.getString("my_session");
	System.out.println("mySession + " + mySession);
}
if (mySession.equals("OFF")) {
	System.out.println("비정상적인 접근입니다. 로그인 해주세요");
	errMsg = URLEncoder.encode("비정상적인 접근입니다. 로그인 해주세요.", "utf-8");
	//response.sendRedirect("/diary/loginForm2.jsp?errMsg=" + errMsg);
	return;
}
//diary테이블 diary_date조회 쿼리
String sql2 = "select diary_date from diary where diary_date = ?";

PreparedStatement stmt2 = null;
ResultSet rs2 = null;

stmt2 = conn.prepareStatement(sql2);
stmt2.setString(1, checkDate);
rs2 = stmt2.executeQuery();

String ck = null;
if (rs2.next()) {
	ck = "F";
	System.out.println("ck = " + ck);
	response.sendRedirect("/diary/addDiaryForm2.jsp?ck=" + ck + "&checkDate=" + checkDate);

} else {
	ck = "T";
	System.out.println("ck = " + ck);
	response.sendRedirect("/diary/addDiaryForm2.jsp?ck=" + ck + "&checkDate=" + checkDate);

}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>checkDateAction</title>
</head>
<body>

</body>
</html>