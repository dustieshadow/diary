<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>

<%
System.out.println("----------loginAction2.jsp");
//loginForm으로부터 받은 id,pw 값을 memberId와 memberPw에 할당
String memberId = request.getParameter("id");
String memberPw = request.getParameter("pw");

System.out.println("memberId : " + memberId);
System.out.println("memberPw : " + memberPw);

//db방식 로그인 제어
String sql = "select my_session mySession from login";

Class.forName("org.mariadb.jdbc.Driver");

Connection conn = null;
//PreparedStatement stmt = null;
//ResultSet rs = null;

conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

//stmt = conn.prepareStatement(sql);
//rs = stmt.executeQuery();

//---- 세션 방식 로그인
//세션을 새로 생성 - "loginMember"라는 문자열
String loginMember =(String)(session.getAttribute("loginMember"));
System.out.println("loginMember :" + loginMember);
//세션이 생성되었을 경우 diary/diary.jsp로 이동
if(loginMember!=null){
	response.sendRedirect("/diary/diary2.jsp");
	return;
}


// 기존 DB방식으로 로그인하는 방식
/*
String mySession = null;
if (rs.next()) {
	mySession = rs.getString("mySession");
}
if (mySession.equals("ON")) {
	System.out.println("이미 접속된 유저입니다. diary2.jsp로 이동합니다");
	//response.sendRedirect("/diary/diary.jsp");
	//return;
}
*/
//db에 저장된 pw와 아이디가 일치하는지 여부 확인
String sql2 = "select member_id memberId from member where member_id = ? and member_pw = ?";

PreparedStatement stmt2 = null;
ResultSet rs2 = null;

stmt2 = conn.prepareStatement(sql2);
stmt2.setString(1, memberId);
stmt2.setString(2, memberPw);
System.out.println("loginMember : "+loginMember );
rs2 = stmt2.executeQuery();

//이미 db에 저장된 my_session값이 "ON"일 경우 sql3를 추가 실행하여 my_session값을 OFF에서 ON으로 변경
if (rs2.next()) {   

	String sql3 = "update login set my_session = 'ON' , on_date = now() where my_session = 'OFF' ";

	PreparedStatement stmt3 = null;

	stmt3 = conn.prepareStatement(sql3);

	int row = stmt3.executeUpdate();

	System.out.println("정상적으로 새로 로그인 되었습니다. diary2.jsp로 이동합니다.");
//	response.sendRedirect("/diary/diary2.jsp?memberId=" + memberId);

} else {

	System.out.println("로그인 실패");
	String errMsg = URLEncoder.encode("회원 정보가 일치하지 않습니다.", "utf-8");
//	response.sendRedirect("/diary/loginForm2.jsp?errMsg=" + errMsg);



}
rs2.beforeFirst();
//로그인 성공했다면-db의 아이디와 패스워드가 조회될 경우
if(rs2.next()){
	System.out.println("세션 로그인 성공");
	session.setAttribute("loginMember",rs2.getString("memberId")); //loginMember라는 문자열에 memberId값 매핑
	response.sendRedirect("/diary/diary2.jsp?memberId=" + memberId);
}else{
	System.out.println("로그인 실패");
	String errMsg = URLEncoder.encode("아이디와 비밀번호를 확인해주세요","utf-8");
	response.sendRedirect("/diary/loginForm2.jsp?errMsg="+errMsg);
	
}

/*
System.out.println("session.getAttribute('loginMember') :" + session.getAttribute("loginMember")); 
//loginMember라는 변수를 넣으면 loginMember의 주소값이 세션에서 조회되기 때문에 null이 반환된다. 문자열 값으로 대입해야 정상적인 출력가능

if(memberId.equals(session.getAttribute("loginMember"))){
	System.out.println("TEST");
}
System.out.println("loginMember : "+loginMember );
*/

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>loginAction2</title>
</head>
<body>

</body>
</html>