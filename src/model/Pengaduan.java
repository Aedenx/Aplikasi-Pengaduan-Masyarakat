package model;

import java.util.Date;

public class Pengaduan {
    private int id;
    private String isi;
    private Date tanggal;
    private String status;
    private String foto; // Properti untuk nama file foto

    // Getter dan Setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getIsi() { return isi; }
    public void setIsi(String isi) { this.isi = isi; }

    public Date getTanggal() { return tanggal; }
    public void setTanggal(Date tanggal) { this.tanggal = tanggal; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getFoto() { return foto; }
    public void setFoto(String foto) { this.foto = foto; }
}