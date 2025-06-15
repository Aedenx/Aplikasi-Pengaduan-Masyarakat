<%@ page import="model.User" %>
<%@ page import="java.sql.*, utils.DBConnection" %>
<%
    // PERBAIKAN: Pengecekan sesi yang sudah terstandarisasi
    User user = (User) session.getAttribute("user");
    if (user == null || !"user".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // PERBAIKAN: Mengambil userId dari objek 'user'
    int userId = user.getId();
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8" />
    <title>Daftar Pengaduan Saya</title>
    <link rel="stylesheet" href="../css/admin_dashboard.css" />
</head>
<body>
    <header class="navbar">
        <div class="navbar-brand">Pengaduan Masyarakat</div>
        <nav class="navbar-menu">
            <a href="dashboard.jsp">Dashboard</a>
            <a href="addPengaduan.jsp">Tambah Pengaduan</a>
            <a href="myPengaduanList.jsp" class="active">Daftar Pengaduan</a>
            <a href="profil.jsp">Profil</a>
            <a href="../logout">Logout</a>
        </nav>
    </header>

    <main class="dashboard-container">
        <h1>Daftar Pengaduan Saya</h1>
        <table class="pengaduan-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Isi Pengaduan</th>
                    <th>Status</th>
                    <th>Tanggal</th>
                    <th>Tanggapan Admin</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection conn = DBConnection.getConnection()) {
                        PreparedStatement stmt = conn.prepareStatement(
                            "SELECT id, isi, status, tanggal, tanggapan FROM pengaduan WHERE user_id = ? ORDER BY tanggal DESC"
                        );
                        stmt.setInt(1, userId);
                        ResultSet rs = stmt.executeQuery();
                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("isi") %></td>
                    <td><%= rs.getString("status") %></td>
                    <td><%= rs.getTimestamp("tanggal") %></td>
                    <td><%= rs.getString("tanggapan") == null ? "-" : rs.getString("tanggapan") %></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                %>
                <tr>
                    <td colspan="5" style="color: red;">Error: <%= e.getMessage() %></td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </main>
</body>
</html>