<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>

<%

// 0. 로그인(인증) 분기
// diary.login.my_session => 'OFF' => redirect("loginForm.jsp")
System.out.println("----------deleteLunch.jsp");
String sql1 = "select my_session mySession from login";
Class.forName("org.mariadb.jdbc.Driver");
Connection conn = null;
PreparedStatement stmt1 = null;
ResultSet rs1 = null;
conn = DriverManager.getConnection(
		"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
stmt1 = conn.prepareStatement(sql1);
rs1 = stmt1.executeQuery();
String mySession = null;
if(rs1.next()) {
	mySession = rs1.getString("mySession");
}
// diary.login.my_session => 'OFF' => redirect("loginForm.jsp")
if(mySession.equals("OFF")) {
	String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
	response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
	return; // 코드 진행을 끝내는 문법 ex) 메서드 끝낼때 return사용
}

String lunchDate = "";
if(request.getParameter("lunchDate")!=null){
	lunchDate = request.getParameter("lunchDate");
}

System.out.println("lunchDate : "+lunchDate);
String sql2 = "delete from lunch where lunch_date = ?";

PreparedStatement stmt2 = null;
stmt2 = conn.prepareStatement(sql2);
stmt2.setString(1,lunchDate);

int row = stmt2.executeUpdate();

String msg = null;
if(row==1){
	System.out.println("메뉴 삭제에 성공했습니다.");
	response.sendRedirect("/diary/staticLunch.jsp?msg="+msg);
	msg = URLEncoder.encode("메뉴삭제에 성공했습니다.","utf-8");
}else{
	System.out.println("실패했습니다.");
	response.sendRedirect("/diary/lunchOne.jsp?lunchDate="+lunchDate+"&msg="+msg);
	msg = URLEncoder.encode("메뉴 삭제에 실패했습니다.","utf-8");
}


%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>

</body>
</html>