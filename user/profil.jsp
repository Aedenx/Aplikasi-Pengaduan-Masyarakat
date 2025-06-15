<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"user".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profil Saya</title>
    <link rel="stylesheet" href="../css/user_dashboard.css">
    <style>
        /* (Style Anda sudah bagus, tidak perlu diubah) */
        .form-container { background-color: #ffffff; padding: 30px 40px; border-radius: 16px; box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08); max-width: 600px; margin: 40px auto; animation: fadeIn 0.6s ease; }
        .profile-table { width: 100%; border-collapse: separate; border-spacing: 0 15px; }
        .profile-table td { font-size: 16px; padding: 10px; vertical-align: top; }
        .profile-table input[type="text"], .profile-table textarea { width: 100%; padding: 12px 15px; font-size: 15px; border: 1px solid #ccc; border-radius: 8px; background-color: #fefefe; transition: all 0.3s ease; }
        .profile-table input[type="text"]:focus, .profile-table textarea:focus { border-color: #3498db; box-shadow: 0 0 6px rgba(52, 152, 219, 0.3); outline: none; }
        input[type="submit"] { background-color: #2c3e50; color: #fff; padding: 12px 24px; font-size: 16px; border: none; border-radius: 8px; cursor: pointer; transition: background-color 0.3s ease, transform 0.2s ease; }
        input[type="submit"]:hover { background-color: #2980b9; transform: translateY(-2px); }
        .profile-header { text-align: center; margin-bottom: 25px; }
        .profile-header img { border-radius: 50%; width: 60px; height: 60px; object-fit: cover; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .profile-header h2 { margin-top: 10px; font-weight: 600; font-size: 20px; }
        .dashboard-container h1 { font-size: 28px; margin-bottom: 5px; text-align: center; }
        .dashboard-container .subtitle { font-size: 15px; text-align: center; color: #666; margin-bottom: 30px; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>
    <header class="navbar">
        <div class="navbar-brand">Pengaduan Masyarakat</div>
        <nav class="navbar-menu">
            <a href="dashboard.jsp">Dashboard</a>
            <a href="addPengaduan.jsp">Tambah Pengaduan</a>
            <a href="myPengaduanList.jsp">Daftar Pengaduan</a>
            <a href="profil.jsp" class="active">Profil</a>
            <a href="../logout">Logout</a>
        </nav>
    </header>

    <div class="dashboard-container">
        <h1>Profil Pengguna</h1>
        <p class="subtitle">Perbarui informasi kontak dan alamat Anda di bawah ini.</p>

        <div class="form-container">
            <div class="profile-header">
                <img src="../img/profil.jpg" alt="Avatar">
                <h2>Halo, <%= user.getUsername() %>!</h2>
            </div>
            <form method="post" action="<%= request.getContextPath() %>/updateProfil">
                <table class="profile-table">
                    <tr>
                        <td>Username</td>
                        <td><input type="text" name="username" value="<%= user.getUsername() %>" readonly></td>
                    </tr>
                    <tr>
                        <td>Nomor Telepon</td>
                        <td><input type="text" name="no_telp" value="<%= user.getNoTelp() != null ? user.getNoTelp() : "" %>" placeholder="Tulis nomor telepon"></td>
                    </tr>
                    <tr>
                        <td>Alamat</td>
                        <td><textarea name="alamat" rows="3" placeholder="Tulis alamat lengkap"><%= user.getAlamat() != null ? user.getAlamat() : "" %></textarea></td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: right;">
                            <input type="submit" value="Simpan Perubahan">
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </div>
</body>
</html>