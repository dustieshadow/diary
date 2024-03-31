<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>

<%
System.out.println("-------lunchOne.jsp");



//------------------비정상접근 로직4
String memberId = request.getParameter("memberId");
String msg = request.getParameter("msg");
System.out.println("memberId : " + memberId);
System.out.println("msg : " + msg);

String loginMember = (String)(session.getAttribute("loginMember"));
if(loginMember == null) {
	String errMsg = URLEncoder.encode("잘못된 접근 입니다. 로그인 먼저 해주세요", "utf-8");
	response.sendRedirect("/diary/loginForm.jsp?errMsg="+errMsg);
	return;
}



//String sql = "select my_session from login";
//Class.forName("org.mariadb.jdbc.Driver");

Connection conn = null;
/*
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
*/
//----------------------------

String lunchDate = "";
String menu = "";

if (request.getParameter("lunchDate") != null) {
	lunchDate = request.getParameter("lunchDate");

}

if (request.getParameter("menu") != null) {
	menu = request.getParameter("menu");

}

System.out.println("lunchDate : " + lunchDate);
System.out.println("menu : " + menu);


int lunchYear = 1;
int lunchMonth = 1;
int lunchDay = 1;


String sLunchMonth = null;
String sLunchDay = null;
String refLunchDate = null;







//------sql2 날짜 메뉴 쿼리 조회하기
String sql2 = "select lunch_date, Year(lunch_date) lunchYear, Month(lunch_date) lunchMonth, day(lunch_date) lunchDay, menu from lunch where lunch_date = ?";




PreparedStatement stmt2 = null;
ResultSet rs2 = null;

stmt2 = conn.prepareStatement(sql2);
stmt2.setString(1, lunchDate);

rs2 = stmt2.executeQuery();

rs2.beforeFirst();

if (rs2.next()) {
	lunchYear = Integer.parseInt(rs2.getString("lunchYear"));
	lunchMonth = Integer.parseInt(rs2.getString("lunchMonth"));
	lunchDay = Integer.parseInt(rs2.getString("lunchDay"));

}

System.out.println("lunchYear : " + lunchYear);

System.out.println("lunchMonth : " + lunchMonth);

System.out.println("lunchDay : " + lunchDay);

String sLunchYear = Integer.toString(lunchYear);

if (lunchMonth < 10) {
	System.out.println("lunchMonth가 10보다 작은 달입니다.");
	sLunchMonth = "0" + Integer.toString(lunchMonth);
	System.out.println("0이 추가되었습니다.");
}else{
	System.out.println("lunchMonth가 10보다 큰 달입니다.");
	sLunchMonth = Integer.toString(lunchMonth);
	System.out.println("그대로 스트링으로 변환되었습니다.");
}

if (lunchDay < 10) {
	System.out.println("lunchDay가 10보다 작은 날짜입니다.");
	sLunchDay = "0" + Integer.toString(lunchDay);
	System.out.println("0이 추가되었습니다.");
}else{
	System.out.println("lunchDay가 10보다 큰 날짜입니다.");
	sLunchDay = Integer.toString(lunchDay);
	System.out.println("그대로 스트링으로 변환되었습니다.");
}


refLunchDate = sLunchYear+ sLunchMonth + sLunchDay;

rs2.beforeFirst();

System.out.println("lunchYear :" + lunchYear);
System.out.println("lunchMonth :" + lunchMonth);
System.out.println("lunchDay :" + lunchDay);
System.out.println("sLunchDay :" + sLunchDay);
System.out.println("sLunchMonth :" + sLunchMonth);
System.out.println("sLunchYear :" +sLunchYear);
System.out.println("refLunchDate :" + refLunchDate);
//String menuDB = null;

//menuDB = rs2.getString("menu");

//-------sql3 해당날짜에 메뉴 db에 인서트하기

if(rs2.next()){
	
System.out.println("해당 날짜가 조회되어 입력을 시도합니다");

String sql3 = "insert into lunch(lunch_date, menu,update_date,create_date) values(?,?,now(),now())";

PreparedStatement stmt3 = null;
stmt3 = conn.prepareStatement(sql3);

stmt3.setString(1,refLunchDate);
stmt3.setString(2,menu);
int row = stmt3.executeUpdate();

if(row==1){
	System.out.println("메뉴 추가에 성공했습니다");
	response.sendRedirect("/lunch/staticLunch.jsp");
}else{
	System.out.println("실패했습니다.");
	response.sendRedirect("/lunch/staticLunch.jsp");
}

}
rs2.beforeFirst();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<%
	if (!(rs2.next())) {
	
		System.out.println("등록된 메뉴가 없습니다. 새로 메뉴를 추가해주세요.");	
	%>
			<form action="/diary/staticLunch.jsp?lunchDate=<%=refLunchDate%>">
				<h1>점심 메뉴 투표하기!</h1>
				<div>
					<label for="한식">한식</label><input id="한식" type="radio" name="menu">
				</div>
				<div>
					<label for="중식">중식</label><input id="중식" type="radio" name="menu">
				</div>
				<div>
					<label for="일식">일식</label><input id="일식" type="radio" name="menu">
				</div>
				<div>
					<label for="양식">양식</label><input id="양식" type="radio" name="menu">
				</div>
				<div>
					<label for="편의점">편의점</label><input id="편의점" type="radio" name="menu">
				</div>
				<div>
					<label for="도시락">도시락</label><input id="도시락" type="radio" name="menu">
				</div>
				<div>
					<label for="기타">기타 : </label><input id="기타" type="text" name="menu">
				</div>
		
				<input type="submit">
		<%
		
		} else {
			
			System.out.println("이미 메뉴가 있습니다.");
				rs2.beforeFirst();
		%>
				<h1><%=memberId%>님의 <%=lunchDate%>일의 메뉴선택!</h1>
		<%
				if (rs2.next()) {
		%>
					<%=rs2.getString("menu")%>
		
		<%
				}
		
		}
		%>





	</form>
	
	<div>
			
		<a href="/diary/deleteLunch.jsp?lunchDate=<%=refLunchDate %>">삭제하기</a>	
	
	
	</div>

</body>
</html>