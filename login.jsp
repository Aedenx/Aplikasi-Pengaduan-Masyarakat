<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <title>Login - Layanan Pengaduan Masyarakat</title>
    <link rel="stylesheet" href="css/login.css">
</head>

<body>
    <h2></h2>
    <div class="container" id="container">
        <div class="form-container sign-up-container">
            <form action="register" method="post">
                <h1>Registrasi</h1>

                <%-- Tampilkan error jika username sudah digunakan --%>
                    <% String error=request.getParameter("error"); if ("username_taken".equals(error)) { %>
                        <p style="color: red;">Username sudah digunakan</p>
                        <% } %>

                            <input type="text" id="username" name="username" required placeholder="Username" />
                            <input type="password" id="password" name="password" required placeholder="Password" />
                            <button>Registrasi</button>
            </form>
        </div>
        <div class="form-container sign-in-container">
            <form action="login" method="post">
                <h1>Login</h1>
                <input type="text" id="username" name="username" required placeholder="Username" />
                <input type="password" id="password" name="password" required placeholder="Password" />
                <button>Login</button>
            </form>
        </div>
        <div class="overlay-container">
            <div class="overlay">
                <div class="overlay-panel overlay-left">
                    <h1>Login sekarang</h1>
                    <p>Masuk ke akun Anda untuk melihat dan mengelola pengaduan</p>
                    <button class="ghost" id="signIn">Login</button>
                </div>
                <div class="overlay-panel overlay-right">
                    <h1>Selamat Datang!</h1>
                    <p>Buat akun untuk mulai menyampaikan pengaduan Anda dengan mudah!</p>
                    <button class="ghost" id="signUp">Registrasi</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Pesan error login -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const urlParams = new URLSearchParams(window.location.search);
            const signUpButton = document.getElementById('signUp');
            const signInButton = document.getElementById('signIn');
            const container = document.getElementById('container');

            // Tampilkan error login
            if (urlParams.get('error') === 'login_failed') {
                const errorMessage = document.createElement("p");
                errorMessage.style.color = "red";
                errorMessage.textContent = "Login gagal! Username atau password salah.";
                document.body.insertBefore(errorMessage, container);
            }

            // ⬅️ PENTING: Aktifkan panel registrasi otomatis
            if (urlParams.get('register') === 'true') {
                container.classList.add("right-panel-active");
            }

            // Tombol manual login/registrasi
            signUpButton.addEventListener('click', () => {
                container.classList.add("right-panel-active");
            });

            signInButton.addEventListener('click', () => {
                container.classList.remove("right-panel-active");
            });
        });
    </script>
</body>

</html>