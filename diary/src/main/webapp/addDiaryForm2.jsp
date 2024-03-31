<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>

<%
System.out.println("--------addDiaryForm2.jsp");

String memberId = request.getParameter("memberId");

String sql = "select my_session from login";

Class.forName("org.mariadb.jdbc.Driver");

Connection conn = null;
//세션 방식 로그인
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
if (rs.next()) {

	mySession = rs.getString("my_session");
}
if (mySession.equals("OFF")) {
	System.out.println("잘못된 접근입니다. 로그인해주세요.");
	String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인해주세요.", "utf-8");
//	response.sendRedirect("/diary/loginForm2.jsp?errMsg=" + errMsg);
	return;
}
//기존에 등록된 날자가 있는지 확인 알고리즘
String checkDate = request.getParameter("checkDate");
String ck = request.getParameter("ck");

if (checkDate == null) {
	checkDate = "";
}
if (ck == null) {
	ck = "";
}

String msg = "";
if (ck.equals("T")) {
	msg = "입력 가능한 날자입니다.";
	System.out.println("ck : " + ck);
} else if (ck.equals("F")) {
	msg = "이미 등록된 날자입니다.";
	System.out.println("ck : " + ck);
}
%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>addDiaryForm2</title>
</head>
		<body>
			<h1><%=memberId%>님의 일기쓰기
			</h1>
			<form action="/diary/checkDateAction2.jsp" method="post">
				<div>
					checkDate :
					<%=checkDate%></div>
				<div>
					ck :
					<%=ck%></div>
				<div>
					날짜 : <input type="date" name="checkDate" value="<%=checkDate%>">
					<span><%=msg%></span>
				</div>
				<div>
					<input type="submit" value="날짜 확인하기">
				</div>
			</form>
			<hr>
			<form action="/diary/addDiaryAction2.jsp" method="post">
		
				<div>
					<input type="hidden" name="memberId" value="<%=memberId%>"
						readonly="readonly">
				</div>
				<div>
					입력날짜 :
	<%
						if (ck.equals("T")) {
	%>
							<input type="text" name="diaryDate" value="<%=checkDate%>" readonly="readonly">
	<%
						} else {
	%>
							<input type="text" name="diaryDate" value="" readonly="readonly">
	<%
						}
	%>
				</div>
				
				<div>
					기분 : <input type="radio" name="feeling" value="&#128512;">&#128512;
						<input type="radio" name="feeling" value="&#128512;">&#128512;
						<input type="radio" name="feeling" value="&#128512;">&#128512;
						<input type="radio" name="feeling" value="&#128512;">&#128512;
						<input type="radio" name="feeling" value="&#128512;">&#128512;
				</div>	
				<div>
					제목 : <input type="text" name="title">
				</div>
				<div>날씨 :
					<select name="weather">
						<option value="맑음">맑음</option>
						<option value="흐림">흐림</option>
						<option value="비">비</option>
						<option value="눈">눈</option>
		
					</select>
				</div>
				<div>
					<textarea rows="7" cols="50" name="content"></textarea>
				</div>
		
	<%
				if (ck.equals("T")) {
	%>
					<div>
						<button type="submit">입력</button>
					</div>
		
	<%
				} else {
	%>
				<div>
					<button type="submit" disabled="disabled">입력</button>
				</div>
	<%
				}
	%>
			</form>
		</body>
</html>