package servlets;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;

public class UserDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login.html");
            return;
        }

        List<Map<String, String>> pengaduanList = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement("SELECT * FROM pengaduan WHERE user_id = ?");
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("id", rs.getString("id"));
                row.put("isi", rs.getString("isi"));
                row.put("status", rs.getString("status"));
                row.put("tanggal", rs.getString("tanggal"));
                pengaduanList.add(row);
            }

            request.setAttribute("pengaduanList", pengaduanList);
            RequestDispatcher rd = request.getRequestDispatcher("user/dashboard.jsp");
            rd.forward(request, response);

        } catch (SQLException e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
