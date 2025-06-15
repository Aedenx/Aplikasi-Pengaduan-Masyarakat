package servlets;

import utils.DBConnection;
import model.User; // Menggunakan model User
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import java.util.List;
import java.io.File;

public class AddPengaduanServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        // PERBAIKAN: Ambil objek User dari sesi
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        // Ambil ID dari objek user
        int userId = user.getId();

        if (!ServletFileUpload.isMultipartContent(request)) {
            response.sendRedirect(request.getContextPath() + "/user/addPengaduan.jsp?error=Form harus mendukung multipart");
            return;
        }

        String isi = null;
        String fileName = null;

        try {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            List<FileItem> items = upload.parseRequest(request);

            for (FileItem item : items) {
                if (item.isFormField()) {
                    if ("isi".equals(item.getFieldName())) {
                        isi = item.getString("UTF-8");
                    }
                } else {
                    if ("foto".equals(item.getFieldName()) && item.getSize() > 0) {
                        fileName = System.currentTimeMillis() + "_" + item.getName();
                        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) uploadDir.mkdir();
                        item.write(new File(uploadDir, fileName));
                    }
                }
            }

            if (isi == null || isi.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/user/addPengaduan.jsp?error=Isi wajib diisi");
                return;
            }

            try (Connection conn = DBConnection.getConnection()) {
                String sql = "INSERT INTO pengaduan(user_id, isi, foto, status, tanggal) VALUES (?, ?, ?, 'terkirim', NOW())";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, userId);
                    stmt.setString(2, isi);
                    stmt.setString(3, fileName);
                    stmt.executeUpdate();
                    response.sendRedirect(request.getContextPath() + "/user/myPengaduanList.jsp?success=1");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/addPengaduan.jsp?error=db");
        }
    }
}