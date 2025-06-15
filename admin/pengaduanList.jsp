<%@ page import="model.User" %>
<%@ page import="java.sql.*, utils.DBConnection, java.util.*" %>
<%
    // PERBAIKAN: Pengecekan sesi yang sudah terstandarisasi
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    List<Map<String, String>> pengaduanList = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection()) {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(
            "SELECT p.id, u.username, u.no_telp, u.alamat, p.isi, p.status, p.tanggal FROM pengaduan p JOIN users u ON p.user_id = u.id ORDER BY p.tanggal DESC"
        );
        while (rs.next()) {
            Map<String, String> p = new HashMap<>();
            p.put("id", rs.getString("id"));
            p.put("username", rs.getString("username"));
            p.put("no_telp", rs.getString("no_telp"));
            p.put("alamat", rs.getString("alamat"));
            p.put("isi", rs.getString("isi"));
            p.put("status", rs.getString("status"));
            p.put("tanggal", rs.getString("tanggal"));
            pengaduanList.add(p);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8" />
    <title>Daftar Pengaduan - Admin</title>
    <link rel="stylesheet" href="../css/admin_dashboard.css" />
</head>
<body>
    <header class="navbar">
        <div class="navbar-brand">Pengaduan Masyarakat</div>
        <nav class="navbar-menu">
            <a href="dashboard.jsp">Dashboard</a>
            <a href="pengaduanList.jsp" class="active">Daftar Pengaduan</a>
            <a href="managePengaduan.jsp">Kelola Pengaduan</a>
            <a href="userList.jsp">Daftar Pengguna</a>
            <a href="historyLaporan.jsp">Riwayat Laporan</a>
            <a href="../logout">Logout</a>
        </nav>
    </header>

    <main class="dashboard-container">
        <h1>Daftar Seluruh Pengaduan</h1>
        <table class="pengaduan-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>No. Telepon</th>
                    <th>Alamat</th>
                    <th>Isi Pengaduan</th>
                    <th>Status</th>
                    <th>Tanggal</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String, String> p : pengaduanList) { %>
                <tr>
                    <td><%= p.get("id") %></td>
                    <td><%= p.get("username") %></td>
                    <td><%= p.get("no_telp") %></td>
                    <td><%= p.get("alamat") %></td>
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