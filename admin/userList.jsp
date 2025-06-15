<%@ page import="model.User, java.util.*, java.sql.*, utils.DBConnection" %> <%-- PERBAIKAN: Import yang hilang ditambahkan --%>
<%
    // Ambil objek User dari sesi
    User user = (User) session.getAttribute("user");

    // Cek jika user tidak ada ATAU rolenya bukan 'admin'
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String, String>> userList = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection()) {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT id, username, role, no_telp, alamat FROM users WHERE role='user' ORDER BY username");
        while (rs.next()) {
            Map<String, String> u = new HashMap<>();
            u.put("id", rs.getString("id"));
            u.put("username", rs.getString("username"));
            u.put("role", rs.getString("role"));
            u.put("no_telp", rs.getString("no_telp"));
            u.put("alamat", rs.getString("alamat"));
            userList.add(u);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8" />
    <title>Daftar Pengguna - Admin</title>
    <link rel="stylesheet" href="../css/admin_dashboard.css" />
</head>
<body>
    <header class="navbar">
        <div class="navbar-brand">Pengaduan Masyarakat</div>
        <nav class="navbar-menu">
            <a href="dashboard.jsp">Dashboard</a>
            <a href="pengaduanList.jsp">Daftar Pengaduan</a>
            <a href="managePengaduan.jsp">Kelola Pengaduan</a>
            <a href="userList.jsp" class="active">Daftar Pengguna</a>
            <a href="historyLaporan.jsp">Riwayat Laporan</a>
            <a href="../logout">Logout</a>
        </nav>
    </header>

    <main class="dashboard-container">
        <h1>Daftar Pengguna</h1>
        <table class="pengaduan-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>No. Telp</th>
                    <th>Alamat</th>
                    <th>Aksi</th>
                </tr>
            </thead>
            <tbody>
                <% for (Map<String, String> u : userList) { %>
                <tr>
                    <td><%= u.get("id") %></td>
                    <td><%= u.get("username") %></td>
                    <td><%= u.get("role") %></td>
                    <td><%= u.get("no_telp") %></td>
                    <td><%= u.get("alamat") %></td>
                    <td>
                        <form action="<%= request.getContextPath() %>/HapusUserServlet" method="post" style="display:inline-block;" onsubmit="return confirm('Yakin ingin menghapus pengguna ini?');">
                            <input type="hidden" name="id" value="<%= u.get("id") %>">
                            <button type="submit" style="background-color:#f44336; color:white; padding:6px; border:none; border-radius:5px; width:100%; cursor:pointer;">Hapus</button>
                        </form>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </main>
</body>
</html>