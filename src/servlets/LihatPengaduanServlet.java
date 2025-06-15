package servlets;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class LihatPengaduanServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        String role = (String) session.getAttribute("role");
        int userId = (int) session.getAttribute("user_id");

        List<Map<String, String>> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            String query = "SELECT p.id, u.username, p.isi, p.status, p.tanggal " +
                           "FROM pengaduan p JOIN users u ON p.user_id = u.id ";
            if ("user".equals(role)) {
                query += "WHERE p.user_id = ?";
            }

            PreparedStatement ps = conn.prepareStatement(query);
            if ("user".equals(role)) {
                ps.setInt(1, userId);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> data = new HashMap<>();
                data.put("id", rs.getString("id"));
                data.put("username", rs.getString("username"));
                data.put("isi", rs.getString("isi"));
                data.put("status", rs.getString("status"));
                data.put("tanggal", rs.getString("tanggal"));
                list.add(data);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        req.setAttribute("pengaduanList", list);
        req.getRequestDispatcher("lihat_pengaduan.jsp").forward(req, res);
    }
}
