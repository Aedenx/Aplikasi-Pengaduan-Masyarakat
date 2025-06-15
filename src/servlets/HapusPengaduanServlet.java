package servlets;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import utils.DBConnection;
import model.User;

@WebServlet("/HapusPengaduanServlet")
public class HapusPengaduanServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // PERBAIKAN: Validasi Admin
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int pengaduanId = Integer.parseInt(request.getParameter("id"));
            // PERBAIKAN: Gunakan DBConnection
            try (Connection conn = DBConnection.getConnection()) {
                PreparedStatement stmt = conn.prepareStatement("DELETE FROM pengaduan WHERE id=?");
                stmt.setInt(1, pengaduanId);
                stmt.executeUpdate();
            }
            response.sendRedirect(request.getContextPath() + "/admin/managePengaduan.jsp?success=delete");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/managePengaduan.jsp?error=db");
        }
    }
}