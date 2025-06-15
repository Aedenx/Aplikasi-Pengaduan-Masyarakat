<%@ page import="model.User" %>
<%@ page import="java.sql.*, utils.DBConnection" %>
<%
    // PERBAIKAN: Pengecekan sesi yang sudah terstandarisasi
    User user = (User) session.getAttribute("user");
    if (user == null || !"user".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // PERBAIKAN: Mengambil userId dari objek 'user', bukan dari sesi lama
    int userId = user.getId();
    int total = 0;
    int selesai = 0;
    try (Connection conn = DBConnection.getConnection()) {
        PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM pengaduan WHERE user_id = ?");
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) total = rs.getInt(1);

        stmt = conn.prepareStatement("SELECT COUNT(*) FROM pengaduan WHERE user_id = ? AND status = 'selesai'");
        stmt.setInt(1, userId);
        rs = stmt.executeQuery();
        if (rs.next()) selesai = rs.getInt(1);
    } catch (Exception e) {
        // Sebaiknya error ditampilkan atau di-log, bukan dibiarkan kosong
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Pengguna</title>
    <link rel="stylesheet" href="../css/admin_dashboard.css">
</head>
<body>
    <header class="navbar">
        <div class="navbar-brand">Pengaduan Masyarakat</div>
        <nav class="navbar-menu">
            <a href="dashboard.jsp" class="active">Dashboard</a>
            <a href="addPengaduan.jsp">Tambah Pengaduan</a>
            <a href="myPengaduanList.jsp">Daftar Pengaduan</a>
            <a href="profil.jsp">Profil</a>
            <a href="../logout">Logout</a>
        </nav>
    </header>

    <main class="dashboard-container">
        <%-- PERBAIKAN: Mengambil username dari objek 'user' --%>
        <h1>Halo, <%= user.getUsername() %></h1>
        <p class="subtitle">Selamat datang di dashboard pengaduan. Di sini kamu bisa melihat status laporanmu.</p>

        <div class="card-container">
            <div class="card">
                <div class="card-title">Total Pengaduan Anda</div>
                <div class="card-value"><%= total %></div>
            </div>
            <div class="card">
                <div class="card-title">Pengaduan Selesai</div>
                <div class="card-value"><%= selesai %></div>
            </div>
        </div>
    </main>
</body>
</html>