<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>

<%
System.out.println("---------------diaryOne2.jsp");

String memberId = request.getParameter("memberId"); //get방식으로 memberId를 받아오는 방식
String diaryDate = request.getParameter("diaryDate");
String msg = request.getParameter("msg");

System.out.println("memberId : " + memberId);
System.out.println("diaryDate : " + diaryDate);
System.out.println("msg : " + msg);

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
String errMsg = null;
if (rs.next()) {
	mySession = rs.getString("my_session");
}
if (mySession.equals("OFF")) {
	System.out.println("비정상적인 접근입니다. 로그인해주세요.");
	errMsg = URLEncoder.encode("비정상적인 접근입니다. 로그인해주세요.", "utf-8");
	response.sendRedirect("/diary/loginForm2.jsp?errMsg=" + errMsg);
	return;
}
//diary 테이블 조회 쿼리
String sql2 = "select diary_date, title, weather, content from diary where diary_date = ?";

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
<title>Insert title here</title>
<!-- Latest compiled and minified CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- 구글폰트 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Annie+Use+Your+Telescope&family=Bad+Script&family=Indie+Flower&family=Nanum+Brush+Script&family=Nanum+Pen+Script&family=Nothing+You+Could+Do&family=Permanent+Marker&family=Reenie+Beanie&family=Shadows+Into+Light&family=Zeyada&display=swap"
	rel="stylesheet">
	

<link href="https://fonts.googleapis.com/css2?family=Dongle&display=swap" rel="stylesheet">
<style>
.container {
	text-align: center;
	width: 400px;
	height: 500px;
}

.otherFont{
  font-family: "Annie Use Your Telescope", cursive;
  font-weight: 400;
  font-style: normal;
}

.zeyada-regular {
  font-family: "Zeyada", cursive;
  font-weight: 400;
  font-style: normal;
}

* {
  font-family: "Dongle", sans-serif;
  font-weight: 400;
  font-style: normal;
  
}



.msgfont {
	font-family: "Bad Script", cursive;
	font-weight: 400;
	font-style: normal;
}

.floatLeft {
	float: left;
	margin-left: 40px;
}

.floatCenter {
	float: center;
	margin-left: 10px;
}

.floatClear {
	clear: both;
}

.floatRight {
	float: right;
	margin-left: 20px;
}

.containerMarginTop{
	margin-top: 20px;
}

.bg1{
 background-image: url("/diary/img/bg3.png");
 background-size: cover;
}

.marginTop {
	margin-top: 113px;
}

.diary{
	background-image: url("/diary/img/note.png");
	background-size: 100%;
}

a {
	text-decoration: none;
	color: #662500;
	text-decoration:  underline;
}

.msg{
	margin-top: 465px;
}

.text-shadow {
    text-shadow: 3px 3px 4px #A4A3C9;
}
</style>
</head>
<body style="height: 700px;" class="bg1">

	<div class="container diary shadow-lg p-3 mb-5 bg-body-tertiary rounded containerMarginTop" style="width: 500px; height: 680px;"  >
		<div class="floatRight"  >
			<div>
				<a class="link-secondary link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover"
					href="/diary/removeDiaryAction2.jsp?memberId=<%=memberId%>&diaryDate=<%=diaryDate%>">Delete</a>
			</div>
			<div>
				<a class="link-secondary link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover"
					href="/diary/modifyDiaryForm2.jsp?memberId=<%=memberId%>&diaryDate=<%=diaryDate%>">Modify</a>
			</div>
		</div>
		<div class="marginTop">
			<div>
				<div class="floatLeft">diary Date :</div>
				<div class="floatCenter">
					<%=diaryDate%></div>
			</div>
	<%
			while (rs2.next()) {
	%>
				<div>
					<div class="floatLeft">title :</div>
					<div class="floatCenter"><%=rs2.getString("title")%></div>
				</div>
				<div>
					<div class="floatLeft floatClear ">weather :</div>
					<div class="floatCenter dongle-regular"><%=rs2.getString("weather")%></div>
				</div>
				<div>
					<div class="floatLeft floatClear">content :</div>
					<div class="floatCenter"><%=rs2.getString("content")%></div>
				</div>
		</div>
	<%
			}
	%>
		<div class="msg msgfont text-shadow">
			Wheresoever you go, go with all your heart.
		</div>
	</div>
<!-- 댓글 추가 폼 -->
	<div>
		<form method="post" action="/diary/addCommentAction.jsp">
		<input type="hidden" name ="diaryDate" value="<%=diaryDate %>">
		<textarea rows="2" cols="50" name="memo"></textarea>
		<button type="submit"></button>
		</form>
	</div>
	<!--  댓글 리스트 -->
	
	<%
		String sql3 = "select comment_no commentNo, memo, create_date createDate from comment where diary_date =?";
		PreparedStatement stmt3 = null;
		ResultSet rs3 = null;
		
		stmt3 = conn.prepareStatement(sql3);
		stmt3.setString(1,diaryDate);
		rs3 = stmt3.executeQuery();
	
	%>
	
	<table border="1">
	<%
		
		while(rs3.next()){
	%>
			<tr>
				<td><%=rs2.getString("memo") %></td>
				<td><%=rs2.getString("memo") %></td>
				<td>
					<a href="/diary/deleteComment2.jsp?commentNo=<%=rs3.getString("commentNo")%>">수정</a></td>
			</tr>
			
	<%
		}
	
	%></table>
</body>
</html>