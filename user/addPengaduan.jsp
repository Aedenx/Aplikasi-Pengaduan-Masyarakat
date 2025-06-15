<%@ page import="model.User" %>
<%
    // PERBAIKAN: Pengecekan sesi yang sudah terstandarisasi
    User user = (User) session.getAttribute("user");
    if (user == null || !"user".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8" />
    <title>Tambah Pengaduan</title>
    <link rel="stylesheet" href="../css/admin_dashboard.css" />
    <link rel="stylesheet" href="../css/addPengaduan.css" />
</head>
<body>
    <header class="navbar">
        <div class="navbar-brand">Pengaduan Masyarakat</div>
        <nav class="navbar-menu">
            <a href="dashboard.jsp">Dashboard</a>
            <a href="addPengaduan.jsp" class="active">Tambah Pengaduan</a>
            <a href="myPengaduanList.jsp">Daftar Pengaduan</a>
            <a href="profil.jsp">Profil</a>
            <a href="../logout">Logout</a>
        </nav>
    </header>

    <main class="dashboard-container">
        <h1>Tambah Pengaduan Baru</h1>
        <p class="subtitle">Silakan isi detail pengaduan Anda di bawah ini.</p>

        <form action="<%= request.getContextPath() %>/addPengaduanServlet" method="post" enctype="multipart/form-data" class="pengaduan-form">
            <label for="isi">Isi Pengaduan:</label>
            <textarea id="isi" name="isi" rows="7" placeholder="Tuliskan detail pengaduan Anda..." required></textarea>
        
            <label for="foto">Upload Foto (opsional):</label>
            <input type="file" name="foto" id="foto" accept="image/*" />
        
            <input type="submit" value="Kirim Pengaduan" class="btn-submit" />
        </form>
    </main>
</body>
</html>