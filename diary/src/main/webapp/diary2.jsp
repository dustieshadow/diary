<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.util.*"%>

<%
System.out.println("---------------diary2.jsp");

//memberId,msg 변수관리
String memberId = request.getParameter("memberId");
String msg = request.getParameter("msg");
System.out.println("memberId : " + memberId);
System.out.println("msg : " + msg);

String sql = "select my_session from login";
Class.forName("org.mariadb.jdbc.Driver");

Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;

conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

//세션 방식
String loginMember = (String)(session.getAttribute("loginMember")); //세션에 loginMember 변수 생성
if(loginMember == null){
	String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요.","utf-8");
	response.sendRedirect("/diary/loginForm2.jsp?errMsg="+errMsg);
	return;
	
}
System.out.println("loginMember : "+loginMember);

//기존 DB방식 로그인
stmt = conn.prepareStatement(sql);
rs = stmt.executeQuery();

String mySession = null;

if (rs.next()) {

	mySession = rs.getString("my_session");
}

if (mySession.equals("OFF")) {
	String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해주세요.", "utf-8");
	System.out.println("비정상접근");
	//response.sendRedirect("/diary/loginForm2.jsp");
	return;
}

//달력 관련 로직
//targetYear == 달력 페이지 넘길때 받는 년도값, targetMonth == 달력 페이지 넘길때 받는 월값
String targetYear = request.getParameter("targetYear");
String targetMonth = request.getParameter("targetMonth");

System.out.println("targetYear : " + targetYear);
System.out.println("targetMonth : " + targetMonth);
//Calendar 함수 사용
//target == 선택날짜 추출 , today == 오늘날짜 추출 , beforeMonth==지난달 추출, afterMonth == 다음달 추출
Calendar target = Calendar.getInstance();
Calendar today = Calendar.getInstance();
Calendar beforeMonth = Calendar.getInstance();
Calendar afterMonth = Calendar.getInstance();

//최초 페이지 진입시 타겟변수에 디폴트 캘린더값 주입
if (targetYear != null && targetMonth != null) {
	target.set(Calendar.YEAR, Integer.parseInt(targetYear));
	target.set(Calendar.MONTH, Integer.parseInt(targetMonth));
}
//요일날짜 추출용도 date 1일로 초기화
target.set(Calendar.DATE, 1);

//tYear, tMonth, yoNum변수에 타겟날짜 주입
int tYear = target.get(Calendar.YEAR);
int tMonth = target.get(Calendar.MONTH);
int yoNum = target.get(Calendar.DAY_OF_WEEK);

System.out.println("tYear : " + tYear);
System.out.println("tMonth : " + tMonth);
System.out.println("yoNum : " + yoNum);

//달력 앞 공백칸 데이터 설정
int startBlank = yoNum - 1;
//해당 달의 마지막 날짜 주입
int lastDate = target.getActualMaximum(Calendar.DATE);
//오늘 date 추출
int todayDate = today.get(Calendar.DATE);

int lastBlank = 0;
//lastBlank(다음달 배정블록) 값 배당 로직
if ((startBlank + lastDate + lastBlank) % 7 != 0) {

	lastBlank = 7 - (startBlank + lastDate + lastBlank) % 7;
}

//countDiv == 달력 날짜(div)생성갯수 설정
int countDiv = startBlank + lastDate + lastBlank;

//지난달
beforeMonth.set(Calendar.DATE, 1);
//지난달 월 값 추출
beforeMonth.set(Calendar.MONTH, tMonth - 1);
//지난달 날짜 최대값 추출
int beforeMonthLastDate = beforeMonth.getActualMaximum(Calendar.DATE);
//다음달 시작날짜
int afterMonthStartDate = 1;

//오늘 달 구하기
int todayMonth = today.get(Calendar.MONTH);
int todayYear = today.get(Calendar.YEAR);

// 디버깅
System.out.println("---------");
System.out.println("lastBlank : " + lastBlank);
System.out.println("todayMonth : " + todayMonth);
System.out.println("todayYear : " + todayYear);
System.out.println("yoNum : " + yoNum);
System.out.println("todayDate : " + todayDate);
System.out.println("targetYear : " + targetYear);
System.out.println("targetMonth : " + targetMonth);
System.out.println("target : " + target);
System.out.println("tYear : " + tYear);
System.out.println("tMonth : " + tMonth);
System.out.println("lastDate : " + lastDate);
System.out.println("countDiv : " + countDiv);
System.out.println("startBlank : " + startBlank);

// sql2  diary테이블에서 diary_date 조회 쿼리
String sql2 = "select diary_date from diary";
PreparedStatement stmt2 = null;
ResultSet rs2 = null;

stmt2 = conn.prepareStatement(sql2);
rs2 = stmt2.executeQuery();
//arrDiaryDate라는 ArrayList 생성 - 메모 입력된 날짜와 비교목적
ArrayList<String> arrDiaryDate = new ArrayList<>();
//arrDiaryDate ArrayList에 메모가 있는 날짜값 주입
while (rs2.next()) {

	String diaryDate = rs2.getString("diary_date");
	arrDiaryDate.add(diaryDate);
	System.out.println("diaryDate : " + diaryDate);
}
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>diary2</title>
<!-- Latest compiled and minified CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<!--  구글폰트 -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Amatic+SC:wght@400;700&family=Annie+Use+Your+Telescope&family=Bad+Script&family=Indie+Flower&family=Nanum+Brush+Script&family=Nanum+Pen+Script&family=Nothing+You+Could+Do&family=Permanent+Marker&family=Reenie+Beanie&family=Shadows+Into+Light&family=Zeyada&display=swap"
	rel="stylesheet">
	

<link href="https://fonts.googleapis.com/css2?family=Dongle&display=swap" rel="stylesheet">
<style>

* {
  font-family: "Dongle", sans-serif;
  font-weight: 400;
  font-style: normal;
}

.yo {
	float: left;
	margin-right: 50px;
}

a {
	text-decoration: none;
	color: black;
}

a:link {
	text-decoration: none;
}

a:active {
	
}

a:visited {
	
}

a:hover {
	font-weight: bold;
}

.floatLeft {
	float: left;
	margin-right: 50px;
}

.red {
	background-color: blue;
}

.floatClear {
	clear: both;
	color: blue;
}
.memo{
	background-image: url("/diary/img/memo.png");
	background-size: cover;
}
</style>
</head>
<body>
	<!-- 처음 페이지 진입시 분기 -->
	<%
	if (targetYear == null && targetMonth == null) {
	%>

	<div>
		<%=tYear%>년
		<%=tMonth + 1%>월 입니다
	</div>
	<% //페이지를 넘겼을 때 분기
	} else {
	%>
	<%=tYear%>년
	<%=tMonth + 1%>월 입니다
	<%
	}
	%>
	<div>
		<a href="/diary/logout2.jsp">로그아웃</a>
	</div>

	<h1><%=memberId%>님의 다이어리
	</h1>

	<div class="yo">SUN</div>
	<div class="yo">MON</div>
	<div class="yo">TUE</div>
	<div class="yo">WED</div>
	<div class="yo">THI</div>
	<div class="yo">FRI</div>
	<div class="yo">SAT</div>



	<%//diaryOne에 넘길 refDiaryDate 변수 생성 - 날짜데이터 스트링 변환값
	String refDiaryDate = null;
	String tMonthString = null;
	String tDateString = null;
	
	//최외곽 for문
	for (int i = 1; i <= countDiv; i++) {

		//일요일 마다 floatClear 진행하는 분기
		if (i % 7 == 1) {
	%>


		<div class="floatLeft floatClear" style="color: red;">
	<%	//평일 float분기
		} else {
	%>
		<div class="floatLeft">
	<%
		}

			// 이번달
				
				if (i - startBlank > 0 && i - startBlank <= lastDate) {
						//int tMonth를 String 변수로 형변환
						if (tMonth < 9) {
							tMonthString = "0" + Integer.toString(tMonth + 1);
						} else {
							tMonthString = Integer.toString(tMonth);
						}
						//int 해당날짜를 String 변수로 형변환
						if (i - startBlank < 10) {
							tDateString = "0" + Integer.toString(i - startBlank);
						} else {
							tDateString = Integer.toString(i - startBlank);
						}
						// diaryOne으로 전송할 String 날짜데이터
						refDiaryDate = tYear + tMonthString + tDateString;				
						
						System.out.println(tYear + "-" + tMonthString + "-" + tDateString);
						
						//선택된 날짜가 메모가 '있다면'
						if (arrDiaryDate.contains(tYear + "-" + tMonthString + "-" + tDateString)) {
							System.out.println("----메모가 있습니다.");
							//'오늘'이라면-선택된 날이 '오늘'인지 확인하는 분기
							if (todayDate == i - startBlank && (todayMonth + 1) == tMonth && todayYear == tYear) {
	%>								<a class="today memo" 
									href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"><%=i - startBlank%></a>
	<%
							//'오늘'이 아니라면
							} else {
								//선택된 날이 '일요일'인지 확인하는 분기
								if (i % 7 == 1) {
	%>								<a class="memo" href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"
									style="color: red;"><%=i - startBlank%></a>
	<%							//선택된 날이 '토요일'인지 확인하는 분기
								} else if (i % 7 == 0) {
	%>								<a class="memo" href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"
									style="color: blue;"><%=i - startBlank%></a>
	<%
								}
								//평일일때
								else {
	%>								<a class="memo" href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"><%=i - startBlank%></a>
	<%
								}
							}
							
						//선택된 날에 메모가 '없다면'
						}else{
							
							//'오늘'이라면-선택된 날이 '오늘'인지 확인하는 분기
							if (todayDate == i - startBlank && (todayMonth + 1) == tMonth && todayYear == tYear) {
	%>								<a class="today"
									href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"><%=i - startBlank%></a>
	<%						//'오늘'이 아니라면
							} else {
								//선택된 날이 '일요일'인지 확인하는 분기
								if (i % 7 == 1) {
	%>							<a href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"
									style="color: red;"><%=i - startBlank%></a>
	<%							//선택된 날이 '토요일'인지 확인하는 분기
								} else if (i % 7 == 0) {
	%>							<a href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"
									style="color: blue;"><%=i - startBlank%></a>
	<%
								}
								//평일일때
								else {
	%>							<a href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"><%=i - startBlank%></a>
	<%
								}
							}
							
						
						}
			
				//이전달
				} else if (i - startBlank <= 0) {
						//int tMonth를 String 변수로 형변환
						if (tMonth < 9) {
						tMonthString = "0" + Integer.toString(tMonth);
			
						} else {
						tMonthString = Integer.toString(tMonth);
						}
						//int 해당날짜를 String 변수로 형변환
						if (beforeMonthLastDate - startBlank + i < 10) {
						tDateString = "0" + Integer.toString(beforeMonthLastDate - startBlank + i);
			
						} else {
						tDateString = Integer.toString(beforeMonthLastDate - startBlank + i);
						}
						// diaryOne으로 전송할 String 날짜데이터
						refDiaryDate = tYear + tMonthString + tDateString;
						
						System.out.println(tYear + "-" + tMonthString + "-" + tDateString);
						
						//선택된 날짜가 메모가 '있다면'
						if (arrDiaryDate.contains(tYear + "-" + tMonthString + "-" + tDateString)) {
							System.out.println("----메모가 있습니다.");
								
							//'오늘'이라면-선택된 날이 '오늘'인지 확인하는 분기
							if (todayDate == beforeMonthLastDate - startBlank + i && (todayMonth + 1) == tMonth && todayYear == tYear) {
	%>						<a class="memo today"
								href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"><%=beforeMonthLastDate - startBlank + i%></a>
	<%						//'오늘'이 아니라면
							} else {
								//선택된 날이 '일요일'인지 확인하는 분기
								if (i % 7 == 1) {
	%>							<a class="memo" href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"
									style="color: red;"><%=beforeMonthLastDate - startBlank + i%></a>
	<%
								}
								//평일일때
								else {
	%>							<a class="memo" href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"><%=beforeMonthLastDate - startBlank + i%></a>
	<%
								}
				
							}
						
						//선택된 날에 메모가 '없다면'
						} else {
							//'오늘'이라면-선택된 날이 '오늘'인지 확인하는 분기
							if (todayDate == beforeMonthLastDate - startBlank + i && (todayMonth + 1) == tMonth && todayYear == tYear) {
	%>								<a class="today"
									href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"><%=beforeMonthLastDate - startBlank + i%></a>
	<%						//'오늘'이 아니라면
							} else {
									//선택된 날이 '일요일'인지 확인하는 분기
									if (i % 7 == 1) {
	%>									<a href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"
										style="color: red;"><%=beforeMonthLastDate - startBlank + i%></a>
	<%
									}
									//평일일때
									else {
									%><a href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"><%=beforeMonthLastDate - startBlank + i%></a>
									<%
									}
					
							}
				
						}

				//다음달
				} else {
							//int tMonth를 String 변수로 형변환
						if (tMonth < 9) {
							tMonthString = "0" + Integer.toString(tMonth + 2);
				
						} else {
							tMonthString = Integer.toString(tMonth);
						}
				
						tDateString = "0" + Integer.toString(afterMonthStartDate);
						// diaryOne으로 전송할 String 날짜데이터
						refDiaryDate = tYear + tMonthString + tDateString;
				
						System.out.println(tYear + "-" + tMonthString + "-" + tDateString);
						//선택된 날짜가 메모가 '있다면'
						if (arrDiaryDate.contains(tYear + "-" + tMonthString + "-" + tDateString)) {
							System.out.println("----메모가 있습니다.");
								//'오늘'이라면-선택된 날이 '오늘'인지 확인하는 분기
								if (todayDate == afterMonthStartDate + 1 && (todayMonth + 1) == tMonth && todayYear == tYear) {
	%>							<a class="today memo"
									href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"><%=afterMonthStartDate++%></a>
	<%							//'오늘'이 아니라면
								} else {
								//선택된 날이 '일요일'인지 확인하는 분기
									if (i % 7 == 1) {
	%>									<a class="memo" href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"
										style="color: red;"><%=afterMonthStartDate++%></a>
	<%							//선택된 날이 '토요일'인지 확인하는 분기
									} else if (i % 7 == 0) {
	%>									<a class="memo" href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"
										style="color: blue;"><%=afterMonthStartDate++%></a>
	<%
									}
									//평일일때
									else {
	%>									<a class="memo" href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"><%=afterMonthStartDate++%></a>
	<%
									}
								}
					
						//선택된 날에 메모가 '없다면'
						} else {
								//'오늘'이라면-선택된 날이 '오늘'인지 확인하는 분기
								if (todayDate == afterMonthStartDate + 1 && (todayMonth + 1) == tMonth && todayYear == tYear) {
	%>								<a class="today"
									href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"><%=afterMonthStartDate++%></a>
	<%							//오늘이 아니라면
								} else {
									//선택된 날이 '일요일'인지 확인하는 분기
									if (i % 7 == 1) {
	%>								<a href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"
										style="color: red;"><%=afterMonthStartDate++%></a>
	<%								//선택된 날이 '토요일'인지 확인하는 분기
									} else if (i % 7 == 0) {
	%>								<a href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"
										style="color: blue;"><%=afterMonthStartDate++%></a>
	<%
									}
									//평일일때
									else {
	%>								<a href="/diary/diaryOne2.jsp?diaryDate=<%=refDiaryDate%>"><%=afterMonthStartDate++%></a>
	<%
									}
								}
							
								
							}
				}
			%>
		</div>
	</div>
	<%
	}
	%>



	<div class="floatClear floatLeft">
		<a
			href="/diary/diary2.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth - 1%> ">이전달</a>
	</div>
	<div class="floatLeft">
		<a
			href="/diary/diary2.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth + 1%>">다음달</a>
	</div>

</body>


</html>