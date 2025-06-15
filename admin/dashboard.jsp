<%@ page import="model.User" %>
<%@ page import="java.sql.*, utils.DBConnection" %>
<%
    // PERBAIKAN: Pengecekan sesi yang sudah terstandarisasi
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    int totalUsers = 0, totalPengaduan = 0, totalSelesai = 0;
    try (Connection conn = DBConnection.getConnection()) {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM users WHERE role = 'user'");
        if (rs.next()) totalUsers = rs.getInt(1);

        rs = stmt.executeQuery("SELECT COUNT(*) FROM pengaduan");
        if (rs.next()) totalPengaduan = rs.getInt(1);

        rs = stmt.executeQuery("SELECT COUNT(*) FROM pengaduan WHERE status = 'selesai'");
        if (rs.next()) totalSelesai = rs.getInt(1);
        
        rs.close();
        stmt.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Admin</title>
    <link rel="stylesheet" href="../css/admin_dashboard.css">
</head>
<body>
    <header class="navbar">
        <div class="navbar-brand">Pengaduan Masyarakat</div>
        <nav class="navbar-menu">
            <a href="dashboard.jsp" class="active">Dashboard</a>
            <a href="pengaduanList.jsp">Daftar Pengaduan</a>
            <a href="managePengaduan.jsp">Kelola Pengaduan</a>
            <a href="userList.jsp">Daftar Pengguna</a>
            <a href="historyLaporan.jsp">Riwayat Laporan</a>
            <a href="../logout">Logout</a>
        </nav>
    </header>
    
    <main class="dashboard-container">
        <%-- PERBAIKAN: Mengambil username dari objek 'user' --%>
        <h1>Halo, <%= user.getUsername() %></h1>
        <p class="subtitle">Ini adalah statistik sistem pengaduan masyarakat.</p>

        <div class="card-container">
            <div class="card">
                <div class="card-title">Total Pengguna</div>
                <div class="card-value"><%= totalUsers %></div>
            </div>
            <div class="card">
                <div class="card-title">Total Pengaduan</div>
                <div class="card-value"><%= totalPengaduan %></div>
            </div>
            <div class="card">
                <div class="card-title">Pengaduan Selesai</div>
                <div class="card-value"><%= totalSelesai %></div>
            </div>
            <div class="card">
                <div class="card-title">Aksi Cepat</div>
                <div class="card-value">
                    <a href="managePengaduan.jsp" style="text-decoration:none;">
                        <button style="padding:10px 15px; background:#007bff; color:white; border:none; border-radius:5px; cursor:pointer;">
                            Kelola Pengaduan
                        </button>
                    </a>
                </div>
            </div>
        </div>
    </main>
</body>
</html>