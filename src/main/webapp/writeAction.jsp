<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page"/>
<jsp:setProperty name="bbs" property="bbsCategory" />
<jsp:setProperty name="bbs" property="bbsTitle" />
<jsp:setProperty name="bbs" property="bbsContent" />

<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="Text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width", initial-scale="1">
        <title>JSP 게시판 웹 사이트</title>
    </head>

    <body>
        
        <%  
            String userID =null;
            if(session.getAttribute("userID") != null){
                userID=(String)session.getAttribute("userID");
            }
            if(userID == null){
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('로그인이 필요합니다.')");
                script.println("location.href = 'login.jsp'");
                script.println("</script>");
            } else{
                if(bbs.getBbsTitle() == null || bbs.getBbsContent() == null){
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('빈칸을 채워 주세요 ♥')");
                script.println("history.back()");
                script.println("</script>");
            }
            else{
                BbsDAO bbsDAO = new BbsDAO();
                int result = bbsDAO.write(bbs.getBbsCategory(),bbs.getBbsTitle(),userID,bbs.getBbsContent());     
                if(result == -1){
                    PrintWriter script = response.getWriter();
                    script.println("<script>");
                    script.println("alert('내용이 길어 작성을 실패하였습니다.(최대 1900자)')"); // -1은 데이터베이스 오류
                    script.println("history.back()");
                    script.println("</script>");
                }
                else{
                    PrintWriter script = response.getWriter();
                    script.println("<script>");
                    script.println("location.href = 'bbs.jsp'");
                    script.println("</script>");
                }
            }

            }
        
            
        %>
    </body>

</html>