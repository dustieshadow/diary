<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>

<%
System.out.println("---------------loginForm2.jsp");

//errMsg 변수관리 - 로그인관련 에러메시지
String errMsg = request.getParameter("errMsg");
System.out.println("errMsg : " + errMsg);


Class.forName("org.mariadb.jdbc.Driver");
//기존 db방식 로그인

//String sql = "select my_session mySession from login";

Connection conn = null;
/*
PreparedStatement stmt = null;
ResultSet rs = null;
*/
conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
/*
stmt = conn.prepareStatement(sql);
rs = stmt.executeQuery();
*/
//my_session 칼럼을 OFF로 전환하는 쿼리
String sql2 = "update login set my_session = 'OFF'";

PreparedStatement stmt2 = null;

stmt2 = conn.prepareStatement(sql2);
int row = stmt2.executeUpdate();


//세션방식 로그인
// 로그인 성공시 세션에 loginMember라는 변수를 만들고 값으로 로그인 아이디를 저장
String loginMember = (String) (session.getAttribute("loginMember"));
System.out.println("loginMember : " + loginMember); //세션이 이미 생성되어있는지 확인

//이미 세션이 열려있다면 diary.jsp페이지로 이동
if (loginMember != null) {
	response.sendRedirect("/diary/diary2.jsp");
	return;
}

//sql이 조회되었을때 mySession 변수에 my_session값 할당
/*
 String mySession = null;
if (rs.next()) {
	mySession = rs.getString("mySession");
	System.out.println("mySession : " + mySession);
} 
*/
//my_session값이 ON일 경우 에러메시지 출력 분기
/*
if (mySession.equals("ON")) {
	System.out.println("로그아웃 후에 새로 접속했습니다.");
	errMsg = URLEncoder.encode("로그아웃후에 새로 접속했습니다.", "utf-8");
	//response.sendRedirect("/diary/loginForm2.jsp?errMsg=" + errMsg);

} 
*/
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>loginForm</title>
<!-- Latest compiled and minified CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
.ctn {
	height: 300px;
	margin-top: 500px;
}

.input {
	
}

.table {
	display: table-cell;
}

.marginSpace {
	margin-right: 100px;
}

.marginTop {
	margin-top: 40px;
}

.center1 {
	text-align: center;
}

.center2 {
	align-content: center;
}

.textshadow {
	text-shadow: black;
	font-weight: 100;
}
</style>
</head>
<body>
	<form action="/diary/loginAction2.jsp" method="post">
		<div class="container mt-3">

			<div class="row">
				<div class="col-4"></div>
				<div
					class="col-4 mt-4 p-5 bg-secondary text-white rounded ctn shadow">
					<h2 class="center1">로그인</h2>

					<table class="marginTop">
						<tr>
							<td><label class="marginSpace" for="id">ID</label></td>
							<td><input class="bg-secondary" type="text" name="id"
								id="id"></td>

						</tr>
						<tr>
							<td><label for="pw">PASSWORD</label></td>
							<td><input class="bg-secondary shadow" type="password"
								name="pw" id="pw"></td>
					</table>
					<div>
						<button type="submit" class="btn btn-dark marginTop">Login</button>
					</div>
				</div>
			</div>
			<div class="center1 marginTop">
				<%
				if (errMsg != null) {
				%>
				<%=errMsg%>
				<%
				}
				%>
			</div>
		</div>
	</form>
</body>
</html>