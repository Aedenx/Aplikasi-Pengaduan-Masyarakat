package servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import utils.DBConnection;
import model.User;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE username = ? AND password = ?");
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));
                user.setAlamat(rs.getString("alamat"));
                user.setNoTelp(rs.getString("no_telp"));

                HttpSession session = req.getSession();
                session.setAttribute("user", user);

                if ("admin".equals(user.getRole())) {
                    res.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp");
                } else {
                    res.sendRedirect(req.getContextPath() + "/user/dashboard.jsp");
                }
            } else {
                res.sendRedirect(req.getContextPath() + "/login.jsp?error=login_failed");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database error saat login.", e);
        }
    }
}