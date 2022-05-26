package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.mysql.cj.x.protobuf.MysqlxDatatypes.Array;

public class BbsDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    public BbsDAO(){
        try {
            String dbURL = "jdbc:mysql://localhost:3306/BBS";
            String dbID = "root";
            String dbPassword = "p852852";
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (Exception e) {
            e.printStackTrace();
        }       
    }

    public String getDate(){
        String SQL = "SELECT NOW()";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();
            if(rs.next()){
                return rs.getString(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ""; //데이터베이스 오류
    }

    public int getNext(){
        String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();
            if(rs.next()){
                return rs.getInt(1)+1; // 마지막 번호에 하나 추가
            }
            return 1; // 첫번째 게시물일경우
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; //데이터베이스 오류
    } 

    public int write(String bbsCategory,String bbsTitle,String userID,String bbsContent){
        String SQL = "INSERT INTO BBS VALUES (?,?,?,?,?,?,?)";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1,getNext());
            pstmt.setString(2,bbsCategory);
            pstmt.setString(3,bbsTitle);
            pstmt.setString(4,userID);
            pstmt.setString(5,getDate());
            pstmt.setString(6,bbsContent);
            pstmt.setInt(7,1);
            
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; //데이터베이스 오류
    }

    public ArrayList<Bbs> getList(int pageNumber){
        String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
        ArrayList<Bbs> list = new ArrayList<Bbs>();
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1,getNext()-(pageNumber-1)*10);
            rs = pstmt.executeQuery();
            while(rs.next()){
                Bbs bbs = new Bbs();
                bbs.setBbsID(rs.getInt(1));
                bbs.setBbsCategory(rs.getString(2));
                bbs.setBbsTitle(rs.getString(3));
                bbs.setUserID(rs.getString(4));
                bbs.setBbsDate(rs.getString(5));
                bbs.setBbsContent(rs.getString(6));
                bbs.setBbsAvailable(rs.getInt(7));
                list.add(bbs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list; //데이터베이스 오류
    }

    public boolean nextPage(int pageNumber){
        String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1";
        ArrayList<Bbs> list = new ArrayList<Bbs>();
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1,getNext()-(pageNumber-1)*10);
            rs = pstmt.executeQuery();
            if(rs.next()){
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; //데이터베이스 오류
    }

    public Bbs getBbs(int bbsID){
        String SQL = "SELECT * FROM BBS WHERE bbsID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1,bbsID);
            rs = pstmt.executeQuery();
            if(rs.next()){
                Bbs bbs = new Bbs();
                bbs.setBbsID(rs.getInt(1));
                bbs.setBbsCategory(rs.getString(2));
                bbs.setBbsTitle(rs.getString(3));
                bbs.setUserID(rs.getString(4));
                bbs.setBbsDate(rs.getString(5));
                bbs.setBbsContent(rs.getString(6));
                bbs.setBbsAvailable(rs.getInt(7));
                return bbs;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; //데이터베이스 오류
    }

    public int update(int bbsID, String bbsCategory, String bbsTitle, String bbsContent){
        String SQL = "UPDATE BBS SET bbsCategory = ?, bbsTitle = ?, bbsContent = ?,bbsDate = ? WHERE bbsID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1,bbsCategory);
            pstmt.setString(2,bbsTitle+"(수정됨)");
            pstmt.setString(3,bbsContent);
            pstmt.setString(4,getDate());
            pstmt.setInt(5,bbsID);
            
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; //데이터베이스 오류
    }

    public int delete(int bbsID){
        String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1,bbsID);
            
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; //데이터베이스 오류

    }

}
