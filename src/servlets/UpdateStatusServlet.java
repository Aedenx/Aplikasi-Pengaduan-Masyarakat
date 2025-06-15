package servlets;

import utils.DBConnection;
import model.User; // Import model User
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

// Anotasi @WebServlet tidak diperlukan jika sudah dipetakan di web.xml
public class UpdateStatusServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        // PERBAIKAN: Gunakan objek User untuk validasi sesi
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Ambil semua parameter dari form
        String idStr = request.getParameter("id");
        String status = request.getParameter("status");
        String tanggapan = request.getParameter("tanggapan"); // Ambil parameter tanggapan

        if (idStr == null || status == null || tanggapan == null) {
            response.sendRedirect(request.getContextPath() + "/admin/managePengaduan.jsp?error=invalid");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            try (Connection conn = DBConnection.getConnection()) {
                // PERBAIKAN: Update query SQL untuk menyertakan kolom tanggapan
                String sql = "UPDATE pengaduan SET status = ?, tanggapan = ? WHERE id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, status);
                    stmt.setString(2, tanggapan);
                    stmt.setInt(3, id);
                    stmt.executeUpdate();
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/managePengaduan.jsp?success=1");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/managePengaduan.jsp?error=db");
        }
    }
}