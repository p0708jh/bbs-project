<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="Content-Type" content="Text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width", initial-scale="1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <title>JSP 게시판 웹 사이트</title>
    <style type="text/css">
        a, a:hover{
            color:black;
            text-decoration: none;
        }
    </style>
</head>

<body>
    <%
        String userID =null;
        if(session.getAttribute("userID") != null){
            userID=(String)session.getAttribute("userID");
        }
        int pageNumber =1;
        if(request.getParameter("pageNumber")!=null){
            pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
        }
    %>
    <nav class="navbar navbar-default">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed"
                data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
                aria-expanded="false">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="../index.html">JSP 게시판</a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li><a href="../index.html">메인</a></li>
                <li class="active"><a href="bbs.jsp">게시판</a></li>
            </ul>
            <%
                if(userID == null){
            %>
                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle"
                            data-toggle="dropdown" role="button" aria-haspopup="true"
                            aria-expanded="false">
                            접속하기
                            <span class="caret">                        
                            </span>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a href="login.jsp">로그인</a></li>
                            <li><a href="join.jsp">회원가입</a></li>
                        </ul>
                    </li>
                </ul>
            <% 
                }
                else{ 
            %>
                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle"
                            data-toggle="dropdown" role="button" aria-haspopup="true"
                            aria-expanded="false">
                            회원관리
                            <span class="caret">                        
                            </span>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a href="logoutAction.jsp">로그아웃</a></li>
                        </ul>
                    </li>
                </ul>

            <% 
                }
            %>
        </div>
    </nav>
    <div class="container">
        <div class="row">
            <table class="table table-striped" style="text-align: center; border: 1px solid blue">
                <thead>
                    <tr>
                        <th style="background: skyblue; text-align: center;">NO</th>
                        <th style="background: skyblue; text-align: center;">카테고리</th>
                        <th style="background: skyblue; text-align: center;">제목</th>
                        <th style="background: skyblue; text-align: center;">작성자</th>
                        <th style="background: skyblue; text-align: center;">작성일</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        //System.out.println("여기도 안나오냐? 페이지넘버는"+pageNumber);
                        BbsDAO bbsDAO = new BbsDAO();
                        ArrayList<Bbs> list = bbsDAO.getList(pageNumber);
                        for(int i=0; i<list.size(); i++){
                        	//System.out.println(i+"번째도는중");
                    %>
                    <tr>
                    	
                        <td><%= list.get(i).getBbsID()%></td>
                        <td><%= list.get(i).getBbsCategory()%></td>
                        <td><a href="view.jsp?bbsID=<%= list.get(i).getBbsID()%>"><%= list.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll("\n","<br>")%></a></td>
                        <td><%= list.get(i).getUserID()%></td>
                        <td><%= list.get(i).getBbsDate().substring(0,11)+list.get(i).getBbsDate().substring(11,13)+" 시 "+list.get(i).getBbsDate().substring(14,16)+" 분 "%></td>
                    </tr>
                    <% 
                        }
                    %>
                </tbody>
            </table>
            <%
                if(pageNumber !=1){
            %>
                <a href="bbs.jsp?pageNumber=<%=pageNumber -1%>" class="btn btn-success btn-arraw-left">이전</a>
            <%
                } if(bbsDAO.nextPage(pageNumber+1)){
            %>
                <a href="bbs.jsp?pageNumber=<%=pageNumber +1%>" class="btn btn-success btn-arraw-left">다음</a>
            <%
                }
            %>
            <a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
        </div>
    </div>
    <script src="http://code.jquery.com/jquery-latest.js"></script>
    <script type="text/javascript" src="js/bootstrap.js"></script>
</body>
</html>