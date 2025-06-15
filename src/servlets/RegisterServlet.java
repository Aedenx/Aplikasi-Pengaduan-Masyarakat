package servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import utils.DBConnection;

public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            // Cek dulu apakah username sudah ada
            PreparedStatement checkUser = conn.prepareStatement("SELECT id FROM users WHERE username = ?");
            checkUser.setString(1, username);
            ResultSet rs = checkUser.executeQuery();

            if (rs.next()) {
                // Jika username sudah ada, kembali ke halaman register
                res.sendRedirect(req.getContextPath() + "/login.jsp?error=username_taken&register=true");
                return;
            }

            // Jika tidak ada, baru insert user baru
            PreparedStatement ps = conn.prepareStatement("INSERT INTO users (username, password, role, alamat, no_telp) VALUES (?, ?, 'user', '', '')");
            ps.setString(1, username);
            ps.setString(2, password); // Ingat, ini belum aman! Pertimbangkan hashing.
            ps.executeUpdate();

            res.sendRedirect(req.getContextPath() + "/login.jsp?register_success=true");
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Kesalahan database saat registrasi.", e);
        }
    }
}