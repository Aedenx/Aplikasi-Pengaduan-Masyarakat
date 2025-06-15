package servlets;
import utils.DBConnection;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;

public class AdminDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("role");
        if (role == null || !role.equals("admin")) {
            response.sendRedirect("../login.html");
            return;
        }

        List<Map<String, String>> pengaduanList = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(
                "SELECT p.id, u.username, p.isi, p.status, p.tanggal FROM pengaduan p JOIN users u ON p.user_id = u.id"
            );
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("id", rs.getString("id"));
                row.put("username", rs.getString("username"));
                row.put("isi", rs.getString("isi"));
                row.put("status", rs.getString("status"));
                row.put("tanggal", rs.getString("tanggal"));
                pengaduanList.add(row);
            }

            request.setAttribute("pengaduanList", pengaduanList);
            RequestDispatcher rd = request.getRequestDispatcher("admin/dashboard.jsp");
            rd.forward(request, response);

        } catch (SQLException e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
