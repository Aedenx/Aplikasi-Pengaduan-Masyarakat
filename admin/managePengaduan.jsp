<%@ page import="model.User" %>
<%@ page import="java.sql.*, utils.DBConnection" %>
<%
    // Pengecekan sesi yang sudah terstandarisasi
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Kelola Pengaduan</title>
    <link rel="stylesheet" href="../css/admin_dashboard.css">
</head>
<body>
    <header class="navbar">
        <div class="navbar-brand">Pengaduan Masyarakat</div>
        <nav class="navbar-menu">
            <a href="dashboard.jsp">Dashboard</a>
            <a href="pengaduanList.jsp">Daftar Pengaduan</a>
            <a href="managePengaduan.jsp" class="active">Kelola Pengaduan</a>
            <a href="userList.jsp">Daftar Pengguna</a>
            <a href="historyLaporan.jsp">Riwayat Laporan</a>
            <a href="../logout">Logout</a>
        </nav>
    </header>

    <main class="dashboard-container">
        <h1>Kelola Pengaduan</h1>
        <p class="subtitle">Berikut adalah daftar pengaduan yang masuk. Anda dapat mengubah status dan memberi tanggapan.</p>
        <table class="pengaduan-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>User</th>
                    <th>Isi Pengaduan</th>
                    <th>Status</th>
                    <th>Tanggal</th>
                    <th>Tanggapan</th>
                    <th>Bukti</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
            <%
                try (Connection conn = DBConnection.getConnection()) {
                    String sql = "SELECT p.id, u.username, p.isi, p.status, p.tanggal, p.foto, p.tanggapan FROM pengaduan p JOIN users u ON p.user_id = u.id ORDER BY p.tanggal DESC";
                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        ResultSet rs = stmt.executeQuery();
                        while (rs.next()) {
                            int id = rs.getInt("id");
                            String username = rs.getString("username");
                            String isi = rs.getString("isi");
                            String status = rs.getString("status");
                            Timestamp tanggal = rs.getTimestamp("tanggal");
                            String foto = rs.getString("foto");
                            String tanggapan = rs.getString("tanggapan");
            %>
                <tr>
                    <td><%= id %></td>
                    <td><%= username %></td>
                    <td><%= isi %></td>
                    <td class="status-<%= status %>"><%= status %></td>
                    <td><%= tanggal %></td>
                    <td><%= tanggapan == null ? "-" : tanggapan %></td>
                    <td>
                        <% if (foto != null && !foto.isEmpty()) { %>
                        <a href="<%= request.getContextPath() + "/uploads/" + foto %>" target="_blank">Lihat</a>
                        <% } else { %> - <% } %>
                    </td>
                    <td>
                        <%-- PERBAIKAN: URL diubah menjadi huruf kecil --%>
                        <form action="<%= request.getContextPath() %>/updateStatusServlet" method="post" style="display:flex; flex-direction:column; gap:6px;">
                            <input type="hidden" name="id" value="<%= id %>">
                            <select name="status">
                                <option value="terkirim" <%= "terkirim".equals(status) ? "selected" : "" %>>Terkirim</option>
                                <option value="diproses" <%= "diproses".equals(status) ? "selected" : "" %>>Diproses</option>
                                <option value="selesai"  <%= "selesai".equals(status) ? "selected" : "" %>>Selesai</option>
                            </select>
                            <textarea name="tanggapan" placeholder="Tulis tanggapan..." rows="2"><%= tanggapan == null ? "" : tanggapan %></textarea>
                            <button type="submit" style="background-color:#4CAF50; color:white; padding:6px; border:none; border-radius:5px; cursor:pointer;">Simpan</button>
                        </form>
                        <form action="<%= request.getContextPath() %>/HapusPengaduanServlet" method="post" onsubmit="return confirm('Yakin ingin menghapus pengaduan ini?');" style="margin-top: 6px;">
                            <input type="hidden" name="id" value="<%= id %>">
                            <button type="submit" style="background-color:#f44336; color:white; padding:6px; border:none; border-radius:5px; width:100%; cursor:pointer;">Hapus</button>
                        </form>
                    </td>
                </tr>
            <%
                        }
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
            </tbody>
        </table>
    </main>
</body>
</html>