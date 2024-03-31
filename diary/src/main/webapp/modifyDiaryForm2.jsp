<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>

<%
System.out.println("---------modifyDiaryForm2.jsp");
String diaryDate = request.getParameter("diaryDate");
String memberId = request.getParameter("memberId");
String msg = request.getParameter("msg");
String title = null;
String weather = null;
String content = null;

System.out.println("diaryDate : " + diaryDate);
System.out.println("memberId : " + memberId);
System.out.println("msg : " + msg);
System.out.println("title : " + title);
System.out.println("weather : " + weather);
System.out.println("content : " + content);

Class.forName("org.mariadb.jdbc.Driver");
//DB방식 로그인 쿼리
String sql = "select my_session from login";

String loginMember = (String)(session.getAttribute("loginMember"));
if(loginMember == null) {
	String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
	response.sendRedirect("/diary/loginForm2.jsp?errMsg="+errMsg);
	return;
}

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
	String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요.", "utf-8");
	System.out.println("비정상접근");
	response.sendRedirect("/diary/loginForm2.jsp");
	return;
}
//diary 테이블 diary_date조회 쿼리
String sql2 = "select diary_date, title, weather, content from diary where diary_date=? ";

PreparedStatement stmt2 = null;
ResultSet rs2 = null;
stmt2 = conn.prepareStatement(sql2);
stmt2.setString(1, diaryDate);

rs2 = stmt2.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ModifyDiaryForm</title>
</head>
		<body>
			<%=msg%>
			<h1>수정</h1>
			<form action="/diary/modifyDiaryAction2.jsp" method="post">
		
	<%
				if (rs2.next()) {
					title = rs2.getString("title");
					weather = rs2.getString("weather");
					content = rs2.getString("content");
	%>
			
					<div>
						diaryDate
						<input type="text" name="diaryDate" value="<%=diaryDate%>" readonly="readonly">
					</div>
					<div>
						title
						<input type="text" name="title" value="<%=title%>">
					</div>
					
					<div>날씨 :
						<select name="weather">
							<option value=""></option>
							<option value="맑음">맑음</option>
							<option value="흐림">흐림</option>
							<option value="비">비</option>
							<option value="눈">맑음</option>
						</select>
					</div>
			
					<div>
						content<input type="text" name="content" value="<%=content%>">
					</div>
	<%
				}
	%>
				<div>
					<input type="submit">
				</div>
			</form>
		</body>
</html>