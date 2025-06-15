package servlets;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        // Ambil sesi yang ada, jangan buat sesi baru jika tidak ada
        HttpSession session = req.getSession(false);
        
        if (session != null) {
            // Hancurkan sesi jika ada
            session.invalidate();
        }

        // Arahkan kembali ke halaman login
        res.sendRedirect(req.getContextPath() + "/login.jsp");
    }
}