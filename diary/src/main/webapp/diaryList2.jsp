<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>

<%
System.out.println("---------------diaryList2.jsp");

String memberId = request.getParameter("memberId");
System.out.println("검색된 searchWord값 : " + request.getParameter("searchWord"));
System.out.println("rowPerPage파라미터값 : " + request.getParameter("rowPerPage"));

//로그인 검사 쿼리-------------------------------
String sql = "select my_session from login";
Class.forName("org.mariadb.jdbc.Driver");

Connection conn = null;
//세션방식 로그인
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

String errMsg = null;
String mySession = null;

if (rs.next()) {
	mySession = rs.getString("my_session");
	System.out.println("mySession : " + mySession);
}
if (mySession.equals("OFF")) {
	System.out.println("비정상적인 접근입니다. 로그인해주세요.");
	errMsg = URLEncoder.encode("비정상적인 접근입니다. 로그인해주세요.", "utf-8");
	//response.sendRedirect("/diary/loginForm2.jsp");
	return;
}

//로그인 검사 쿼리 종료---------------------------
//전체행수 검색 변수설정 -------------------------
int totalRow = 0;			//조회쿼리 전체행수
int rowPerPage = 5; 		//페이지당 행수
int totalPage = 1;			//전체 페이지수

int currentPage = 1;		//현재 페이지수
int limitStartPage = 0;		//limit쿼리 시작행

System.out.println("totalRow : " + totalRow);
System.out.println("rowPerPage : " + rowPerPage);
System.out.println("totalRow % rowPerPage : " + totalRow % rowPerPage);
System.out.println("totalPage : " + totalPage);
//현재 페이지 값이 넘어왔을 때 커런트 페이지 값을 넘겨받는다
if (request.getParameter("currentPage") != null) {
	currentPage = Integer.parseInt(request.getParameter("currentPage"));
	System.out.println("currentPage : " + currentPage);
}
//로우퍼 페이지 값이 넘어왔을때 로우퍼 페이지 값을 넘겨받는다
if (request.getParameter("rowPerPage") != null) {
	rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	System.out.println("rowPerPage : " + rowPerPage);
}
//limit쿼리 시작행수는 현재 페이지에 1을 뺀 수에서 로우퍼페이지를 곱을 한 값이다
limitStartPage = (currentPage - 1) * rowPerPage;
System.out.println("limitStartPage : " + limitStartPage);
//기본 검색 쿼리-------------------------------
String sql2 = "select diary_date, title, weather, feeling from diary limit ?,? ";

PreparedStatement stmt2 = null;
ResultSet rs2 = null;
stmt2 = conn.prepareStatement(sql2);

stmt2.setInt(1, limitStartPage);
stmt2.setInt(2, rowPerPage);

System.out.println(stmt2);
rs2 = stmt2.executeQuery();
//전체 토탈행수 검색 쿼리-------------------------------
String sql3 = "select count(*) totalRow from diary";

PreparedStatement stmt3 = null;
ResultSet rs3 = null;

stmt3 = conn.prepareStatement(sql3);

rs3 = stmt3.executeQuery();
//totalRow 변수는 count(*) 값이다. - 전체행수
if (rs3.next()) {
	totalRow = rs3.getInt("totalRow");
	System.out.println("totalRow : " + totalRow);

}
//전체행수가 로우퍼페이지 수로 나눠도 나머지가 남을 때 전체페이지에 +1 해준다
if (totalRow % rowPerPage != 0) {
	totalPage = totalRow / rowPerPage + 1;
//전체행수가 로우퍼페이지 수에 딱 떨어지는 수일 때 전체페이지에 +1 해준다
} else {
	totalPage = totalRow / rowPerPage;
}
//토탈행수 변수 디버깅-------------------------

System.out.println("totalPage : " + totalPage);
System.out.println("currentPage : " + currentPage);
System.out.println("rowPerPage : " + rowPerPage);

//검색키워드 변수설정------------------
String searchWord = "";
//searchWord(검색키워드) 값을 넘겨받아 변수에 대입
if (request.getParameter("searchWord") != null) {

	searchWord = request.getParameter("searchWord");

}

//sql4(diary 테이블) 칼럼값 받을 변수 생성-title검색시 출력할 DB데이터
String diaryDate = null;
String weather = null;
String feeling = null;
//title 검색 조회 쿼리-------------------------------
String sql4 = "select diary_date, title, weather, feeling from diary where title like ? order by diary_date desc limit ?, ? ";

PreparedStatement stmt4 = null;
ResultSet rs4 = null;
//title 검색조회 변수설정- 검색했을때의 페이지 변수 생성. s는 searchWord의 약자
int sTotalRow = 0;			//조회쿼리 전체행수 -검색
int sRowPerPage = 15;		//페이지당 행수	 -검색
int sTotalPage = 1;			//전체 페이지수	 -검색
int sCurrentPage = 1;		//현재 페이지	 -검색
int sLimitStartPage = 0;	//리미트 쿼리에 들어갈 시작행수 - 검색
//title 검색 변수 디버깅
System.out.println("sTotalRow : " + sTotalRow);
System.out.println("sRowPerPage : " + sRowPerPage);
System.out.println("sTotalRow % sRowPerPage : " + sTotalRow % sRowPerPage);
System.out.println("sTotalPage : " + sTotalPage);
//타이틀 검색 현재페이지 변수값 설정
if (request.getParameter("sCurrentPage") != null) {
	sCurrentPage = Integer.parseInt(request.getParameter("sCurrentPage"));
	System.out.println("sCurrentPage : " + sCurrentPage);
}
//타이틀 검색조회 마지막페이지 설정
sLimitStartPage = (sCurrentPage - 1) * sRowPerPage;
System.out.println("sLimitStartPage : " + sLimitStartPage);

stmt4 = conn.prepareStatement(sql4);
stmt4.setString(1, "%" + searchWord + "%");
stmt4.setInt(2, sLimitStartPage);
stmt4.setInt(3, sRowPerPage);


rs4 = stmt4.executeQuery();
//검색단어 전체행수 출력 쿼리---------------------------
String sql6 = "select count(*) totalRow from diary where title like ?";
PreparedStatement stmt6 = null;
ResultSet rs6 = null;

stmt6 = conn.prepareStatement(sql6);
stmt6.setString(1, "%" + searchWord + "%");
rs6 = stmt6.executeQuery();
//타이틀검색조회 sTotalRow에 전체행수 대입
if (rs6.next()) {
	sTotalRow = rs6.getInt("totalRow");
	System.out.println("sTotalRow : " + sTotalRow);

}
//검색 전체행수를 로우퍼페이지로 나눴을때 나머지가 있을 경우
if (sTotalRow % sRowPerPage != 0) {
	sTotalPage = sTotalRow / sRowPerPage + 1;
} else {  //검색 전체행수를 로우퍼페이지로 나눴을때 딱 떨어질 경우
	sTotalPage = sTotalRow / sRowPerPage;
}
System.out.println("sTotalRow : " + sTotalRow);
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


.bg1{
 background-image: url("/diary/img/bg3.png");
 background-size: cover;
}

.floatLeft {
	float: left;
	margin-left: 1px;
}
.floatLeft2{
		float: left;
	margin-left: 70px;
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

.floatRight2 {
	float: right;
	margin-left: 10px;
}

.containerMarginTop{
	margin-top: 20px;
}





.marginTop {
	margin-top: 113px;
}

.marginBottom{
	margin-bottom: 1.3px;
}


.diary{
	background-image: url("/diary/img/note.png");
	background-size: 100%;
}

a {
	text-decoration: none;
	color: #D1B2FF;

}


a:hover {
 
  font-style: italic;
  
}

.font{
	color: #FFB2D9;
}

.text-shadow {
    text-shadow: 3px 3px 4px #5D5D5D;
}

 /* #A4A3C9; */

.msg{
	margin-top: 10px;
	text-align: center;
		
}

.msgfont {
	font-family: "Bad Script", cursive;
	font-weight: 400;
	font-style: normal;
}


.otherFont {
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

.nav{
	margin-top: 100px;
}

.containerAHeight{
	height: 10px;
}

.containerHeight{
	margin-bottom: 10px;
}

.a_marginRight{
	margin-right: 70px;
	
}

.a_textColor1{
	color: #FF7171;
}

.a_textColor2{
	color: #FF8585;
}


</style>

</head>
<body class="bg1" >
	<!-- 본문 -->
	<div style="height: 700px;" class="row">
		<div class="col"></div>
		
		<div class="col" style="padding-right: 0px;">
		<!-- 글귀 -->
		<div class="msg msgfont text-shadow msg-margin-bottom containerAHeight" style="height: 30px;margin-top: 30px;">
			Wheresoever you go, go with all your heart.
		</div>
		
		<!-- 컨테이너 -->
		<div class="container diary shadow-lg p-3 bg-body-tertiary rounded containerMarginTop containerHeight" style="width: 500px; height: 680px;"  >
				<div class="row">
					<!--좌측공백-->
					<div class="col-1"></div>
					<!--중앙-->
					<div class="col-10 marginTop">
						<!-- diaryList로 값 전송 -->
						<form action="/diary/diaryList2.jsp" method="get">
	<%						//diary 테이블에서 추출한 데이터 저장할 변수생성
							diaryDate = null;
							String title = null;
							weather = null;
							//검색 단어가 없을때, 혹은 기본 첫 페이지 진입시
							if (searchWord == null || searchWord.equals("")) {
								//diary 테이블에서 쿼리 조회 값 추출
								while (rs2.next()) {
									diaryDate = rs2.getString("diary_date");
									title = rs2.getString("title");
									weather = rs2.getString("weather");
									feeling = rs2.getString("feeling");
	%>
									<div class="floatLeft">
										<a href="/diary/diaryOne2.jsp?diaryDate=<%=diaryDate%>"><%=diaryDate%></a>
									</div>
									<div class="floatLeft2 font"><%=title%></div>
									<div class="floatRight2">
									<!-- 날씨마다 출력되는 이미지 -->		
 	<% 								if (weather.equals("맑음")) { %>
										<img style="width: 15px; height: 15px;" src="/diary/img/Clear.png">
	<%								} else if (weather.equals("흐림")) { %>
									    <img style="width: 15px; height: 15px;" src="/diary/img/Cloudy.png">
	<%								} else if (weather.equals("비")) { %>
									    <img style="width: 15px; height: 15px;" src="/diary/img/Rain.png">
	<%								} else if (weather.equals("눈")) { %>
									    <img style="width: 15px; height: 15px;"  src="/diary/img/Snow.png">
	<%								} %>
									</div>
									<div class="floatClear marginBottom"></div>
	<%
							}
						//검색 단어가 있을 때		
						} else {
							//검색한 값에 대한 쿼리 조회 출력
							while (rs4.next()) {
								diaryDate = rs4.getString("diary_date");
								title = rs4.getString("title");
								weather = rs4.getString("weather");
	%>
								<div class="floatLeft">
									<a href="/diary/diaryOne2.jsp?diaryDate=<%=diaryDate%>"><%=diaryDate%></a>
								</div>
								<div class="floatLeft2 font"><%=title%></div>
								<div class="floatRight2">
								<!-- 날씨값에 따른 이미지 출력 -->
	<% 							if (weather.equals("맑음")) { %>
						       		<img style="width: 15px; height: 15px;" src="/diary/img/Clear.png">
	<%							} else if (weather.equals("흐림")) { %>
						      		<img style="width: 15px; height: 15px;" src="/diary/img/Cloudy.png">
	<% 							} else if (weather.equals("비")) { %>
						        	<img style="width: 15px; height: 15px;" src="/diary/img/Rain.png">
	<% 							} else if (weather.equals("눈")) { %>
						     	 	<img style="width: 15px; height: 15px;" src="/diary/img/Snow.png">
	<% 							} %>
								</div>
								<div class="floatClear marginBottom"></div>
	<%
							}
	%>				
	<%
						}
	%>
						</form>
					</div>
				</div>
			</div>
			</div>
			<div class="col" style="margin-top: 100px; padding-left: 0px;">
		

						<!-- 페이징 버튼 -->	
						<button type="submit">전체목록보기</button>
						<form method="get" action="/diary/diaryList2.jsp">
							<div>
							
							
								<input type="text" name="searchWord">
								<button type="button" class="btn btn-light btn-sm">title search</button>
								
							</div>
							<div>
								<select name="rowPerPage">
	<%
									if (rowPerPage == 5) {
	%>
										<option value="5">5</option>
										<option value="10">10</option>
										<option value="15">15</option>
										<option value="20">20</option>
	<%
									} else if (rowPerPage == 10) {
	%>
										<option value="5">5</option>
										<option value="10" selected="selected">10</option>
										<option value="15">15</option>
										<option value="20">20</option>
	<%
									} else if (rowPerPage == 15) {
	%>
										<option value="5">5</option>
										<option value="10">10</option>
										<option value="15" selected="selected">15</option>
										<option value="20">20</option>
	<%
									} else if (rowPerPage == 20) {
	%>
										<option value="5">5</option>
										<option value="10">10</option>
										<option value="15">15</option>
										<option value="20" selected="selected">20</option>
	<%
									}
	%>
								</select>
								<button type="submit">목록갯수변경</button>

						</div>
					</form>
		</div>
	</div>
		<div class="container" style="text-align: left; margin-top: 0px; height: 80px;" " >
		<div class="row">
				<div class="col-0"></div>
				<div class="col" style="margin-top: 10px;" >
					<nav class="nav a_textColor1" aria-label="Page navigation" style="margin-top: 15px; height:30px;">
						<ul class="justify-content-center">
							
				<%			//검색 단어가 없을때, 초기 진입 디폴트값
							if (searchWord == null || searchWord.equals("")) {
								//현재 페이지가 1 이상일때
								if (currentPage > 1) {
				%>
									<li class="floatLeft a_textColor2"  >
										<span class="a_marginRight"><a class="page-link"
										href="/diary/diaryList2.jsp?currentPage=1&searchWord=<%=searchWord%>&rowPerPage=<%=rowPerPage%>">처음페이지</a></span></li>
									<li class="floatLeft a_textColor2">
										<span class="a_marginRight"><a class="page-link"
										href="/diary/diaryList2.jsp?currentPage=<%=currentPage - 1%>&searchWord=<%=searchWord%>&rowPerPage=<%=rowPerPage%>">이전페이지</a></span>
									</li>
				<%				//현재 페이지가 1보다 작을때
								} else {
				%>
									<li class="page-item floatLeft" style="color: gray;">
										<span class="a_marginRight disabled"><a class="page-link" style="color: gray;"
										href="/diary/diaryList2.jsp?currentPage=1&searchWord=<%=searchWord%>&rowPerPage=<%=rowPerPage%>">처음페이지</a></span>
									</li>
									<li class="page-item floatLeft" style="color: gray;">
									<span class="a_marginRight disabled"><a class="page-link" style="color: gray;"
										href="/diary/diaryList2.jsp?currentPage=<%=currentPage - 1%>&searchWord=<%=searchWord%>&rowPerPage=<%=rowPerPage%>">이전페이지</a></span>
									</li>
				<%
								}
										
								//현재 페이지가 최종페이지가 작을 때
								if (currentPage < totalPage) {
				%>
									<li class="floatLeft">
										<span class="a_marginRight"><a class="page-link"
										href="/diary/diaryList2.jsp?currentPage=<%=currentPage + 1%>&searchWord=<%=searchWord%>&rowPerPage=<%=rowPerPage%>">다음페이지</a></span>
									</li>
									<li class="floatLeft">
										<span class="a_marginRight"><a class="page-link"
										href="/diary/diaryList2.jsp?currentPage=<%=totalPage%>&searchWord=<%=searchWord%>&rowPerPage=<%=rowPerPage%>">마지막페이지</a></span></li>
				<%				//현재 페이지가 최종페이지보다 같거나 클 때
								} else {
				%>
									<li class="page-item floatLeft" style="color: gray;">
										<span class="a_marginRight disabled"><a class="page-link" style="color: gray;"
										href="/diary/diaryList2.jsp?currentPage=<%=currentPage + 1%>&searchWord=<%=searchWord%>&rowPerPage=<%=rowPerPage%>">다음페이지</a></span></li>
									<li class="page-item floatLeft" style="color: gray;">
										<span class="a_marginRight disabled"><a class="page-link" style="color: gray;"
										href="/diary/diaryList2.jsp?currentPage=<%=totalPage%>&searchWord=<%=searchWord%>&rowPerPage=<%=rowPerPage%>">마지막페이지</a></span></li>
				<%
								}
								
							//검색 단어가 있을때
							} else if (searchWord != null) {
								//검색 단어 현재페이지가 1보다 클 때
								if (sCurrentPage > 1) {
				%>
									<li class="floatLeft">
									<span class="a_marginRight"><a class="page-link"
										href="/diary/diaryList2.jsp?sCurrentPage=1&searchWord=<%=searchWord%>&rowPerPage=<%=rowPerPage%>">처음페이지</a></span></li>
									<li class="floatLeft">
									<span class="a_marginRight"><a class="page-link"
										href="/diary/diaryList2.jsp?sCurrentPage=<%=sCurrentPage - 1%>&searchWord=<%=searchWord%>&rowPerPage=<%=rowPerPage%>">이전페이지</a></span>
									</li>
									<%
								//검색단어 현재 페이지가 1보다 작거나 같을 때
								} else {
				%>
									<li class="page-item floatLeft" style="color: gray;">
									<span class="a_marginRight disabled"><a class="page-link" style="color: gray; disabled"
										href="/diary/diaryList2.jsp?sCurrentPage=1&searchWord=<%=searchWord%>&rowPerPage=<%=rowPerPage%>">처음페이지</a></span>
									</li>
									<li class="page-item floatLeft" style="color: gray;">
									<span class="a_marginRight disabled"><a class="page-link" style="color: gray; disabled"
										href="/diary/diaryList2.jsp?sCurrentPage=<%=sCurrentPage - 1%>&searchWord=<%=searchWord%>&rowPerPage=<%=rowPerPage%>">이전페이지</a></span>
									</li>
				<%
								}
								//검색단어 현재 페이지가 전체 페이지보다 작거나 같을 때
								if (sCurrentPage < sTotalPage) {
				%>
									<li class="floatLeft">
									<span class="a_marginRight"><a class="page-link"
										href="/diary/diaryList2.jsp?sCurrentPage=<%=sCurrentPage + 1%>&searchWord=<%=searchWord%>&rowPerPage=<%=rowPerPage%>">다음페이지</a></span>
									</li>
									<li class="floatLeft">
									<span class="a_marginRight"><a class="page-link" 
										href="/diary/diaryList2.jsp?sCurrentPage=<%=sTotalPage%>&searchWord=<%=searchWord%>&rowPerPage=<%=rowPerPage%>">마지막페이지</a></span></li>
				<%				//검색 단어 현재 페이지가 전체 페이지보다 클 때
								} else {
				%>
									<li class="page-item floatLeft" style="color: gray;">
									<span class="a_marginRight disabled"><a class="page-link" style="color: gray; diabled"
										href="/diary/diaryList2.jsp?sCurrentPage=<%=sCurrentPage + 1%>&searchWord=<%=searchWord%>&rowPerPage=<%=rowPerPage%>">다음페이지</a></span></li>
									<li class="page-item floatLeft" style="color: gray;">
									<span class="a_marginRight disabled"><a class="page-link" style="color: gray; disabled"
										href="/diary/diaryList2.jsp?sCurrentPage=<%=sTotalPage%>&searchWord=<%=searchWord%>&rowPerPage=<%=rowPerPage%>">마지막페이지</a></span></li>
				<%
								}
				
							}
				%>
						</ul>
					</nav>
				</div>
				<div class="col-0"></div>
		
			</div>
		</div>
	
</body>
</html>