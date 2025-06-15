package servlets;

import model.User;
import utils.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/updateProfil")
public class UpdateProfilServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String noTelp = request.getParameter("no_telp");
        String alamat = request.getParameter("alamat");

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "UPDATE users SET no_telp = ?, alamat = ? WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, noTelp);
            stmt.setString(2, alamat);
            stmt.setInt(3, user.getId());
            stmt.executeUpdate();

            // Update user object di session
            user.setNoTelp(noTelp);
            user.setAlamat(alamat);
            session.setAttribute("user", user);

            response.sendRedirect(request.getContextPath() + "/user/profil.jsp?success=true");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/profil.jsp?error=db");
        }
    }
}