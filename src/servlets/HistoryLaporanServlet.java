package servlets;

import model.Pengaduan;
import model.User;
import utils.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/HistoryLaporanServlet")
public class HistoryLaporanServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // PERBAIKAN: Validasi Admin
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<Pengaduan> laporan = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT id, isi, tanggal, status, foto FROM pengaduan WHERE status = 'selesai' ORDER BY tanggal DESC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Pengaduan p = new Pengaduan();
                p.setId(rs.getInt("id"));
                p.setIsi(rs.getString("isi"));
                p.setTanggal(rs.getTimestamp("tanggal"));
                p.setStatus(rs.getString("status"));
                p.setFoto(rs.getString("foto"));
                laporan.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("laporan", laporan);
        RequestDispatcher dispatcher = request.getRequestDispatcher("admin/historyLaporan.jsp");
        dispatcher.forward(request, response);
    }
}