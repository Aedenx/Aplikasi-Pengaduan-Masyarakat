# Gunakan image dasar resmi Tomcat 9 yang berjalan di Java 17 (kombinasi yang stabil)
FROM tomcat:9.0-jdk17-temurin

# Hapus webapps default dari Tomcat agar aplikasi kita menjadi aplikasi utama
RUN rm -rf /usr/local/tomcat/webapps/*

# Salin semua folder dan file web-content dari proyek Anda ke dalam folder ROOT di dalam server
COPY ./WEB-INF /usr/local/tomcat/webapps/ROOT/WEB-INF
COPY ./admin /usr/local/tomcat/webapps/ROOT/admin
COPY ./user /usr/local/tomcat/webapps/ROOT/user
COPY ./css /usr/local/tomcat/webapps/ROOT/css
COPY ./img /usr/local/tomcat/webapps/ROOT/img
COPY ./login.jsp /usr/local/tomcat/webapps/ROOT/login.jsp