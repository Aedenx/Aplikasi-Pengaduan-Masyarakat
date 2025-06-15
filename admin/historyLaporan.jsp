<%@ page import="model.User, java.util.*, java.sql.*, utils.DBConnection" %> <%-- PERBAIKAN: Import yang hilang ditambahkan --%>
<%
    // Ambil objek User dari sesi
    User user = (User) session.getAttribute("user");

    // Cek jika user tidak ada ATAU rolenya bukan 'admin'
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String, String>> laporanList = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection()) {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(
            "SELECT id, isi, status, tanggal FROM pengaduan WHERE status = 'selesai' ORDER BY tanggal DESC"
        );
        while (rs.next()) {
            Map<String, String> p = new HashMap<>();
            p.put("id", rs.getString("id"));
            p.put("isi", rs.getString("isi"));
            p.put("status", rs.getString("status"));
            p.put("tanggal", rs.getString("tanggal"));
            laporanList.add(p);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Riwayat Pengaduan - Admin</title>
    <link rel="stylesheet" href="../css/admin_dashboard.css">
</head>
<body>
    <header class="navbar">
        <div class="navbar-brand">Pengaduan Masyarakat</div>
        <nav class="navbar-menu">
            <a href="dashboard.jsp">Dashboard</a>
            <a href="pengaduanList.jsp">Daftar Pengaduan</a>
            <a href="managePengaduan.jsp">Kelola Pengaduan</a>
            <a href="userList.jsp">Daftar Pengguna</a>
            <a href="historyLaporan.jsp" class="active">Riwayat Laporan</a>
            <a href="../logout">Logout</a>
        </nav>
    </header>

    <main class="dashboard-container">
        <h1>Riwayat Laporan Selesai</h1>
        <table class="pengaduan-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Isi Pengaduan</th>
                    <th>Status</th>
                    <th>Tanggal</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String, String> p : laporanList) { %>
                <tr>
                    <td><%= p.get("id") %></td>
                    <td><%= p.get("isi") %></td>
                    <td><%= p.get("status") %></td>
                    <td><%= p.get("tanggal") %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </main>
</body>
</html>