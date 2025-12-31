# Pterodactyl Panel & Wings Auto Installer
## Ubuntu 24.04 LTS + Nginx + Docker

Script lengkap untuk instalasi dan optimasi Pterodactyl Panel & Wings dengan performa maksimal.

**🆕 UPDATE V2.0:**
- ✅ **Wings Auto Installer** - Install daemon/node otomatis!
- ✅ **Quick Start Menu V2** - Panel + Wings terintegrasi!
- ✅ **Bug Fixes** - Application Key & MySQL Access Denied fixed!

---

## 📦 Daftar Script Lengkap

### **PANEL SCRIPTS:**

#### 1. **pterodactyl-installer.sh** - Panel Auto Installer ⭐ UPDATED
- ✅ Instalasi otomatis Pterodactyl Panel versi terbaru
- ✅ Konfigurasi PHP 8.2 dengan ekstensi lengkap
- ✅ Setup MariaDB dengan keamanan optimal (FIXED: MySQL Access Denied)
- ✅ Konfigurasi Redis untuk caching
- ✅ Setup Nginx dengan SSL (Let's Encrypt)
- ✅ Konfigurasi Queue Worker otomatis
- ✅ Firewall configuration (UFW)
- ✅ Cron jobs untuk scheduled tasks
- ✅ **FIXED: Application Key generation & verification**
- ✅ **FIXED: Multiple fallback methods untuk MySQL password**

#### 2. **pterodactyl-optimizer.sh** - Panel Optimizer
- ✅ Optimasi PHP-FPM berdasarkan RAM sistem
- ✅ Optimasi Nginx dengan worker processes dinamis
- ✅ Tuning MariaDB/MySQL untuk performa maksimal
- ✅ Konfigurasi Redis dengan memory management
- ✅ Kernel parameter optimization
- ✅ FastCGI caching
- ✅ OPcache configuration
- ✅ Monitoring script
- ✅ Automatic backup sebelum optimasi

#### 3. **fix-common-issues.sh** - Fix Script
Script khusus untuk memperbaiki masalah umum Panel:
- [1] Fix Application Key (APP_KEY empty/not set)
- [2] Fix MySQL Access Denied (ERROR 1045)
- [3] Fix Database Connection Issues
- [4] Fix All Permissions
- [5] Complete System Check & Fix

### **WINGS SCRIPTS:** 🦅 NEW!

#### 4. **wings-installer.sh** - Wings Auto Installer 🆕
- ✅ Install Docker & Docker Compose otomatis
- ✅ Download Wings versi terbaru
- ✅ Setup systemd service
- ✅ Konfigurasi firewall untuk game servers
- ✅ Setup SSL certificate (optional)
- ✅ Optimasi kernel parameters untuk game servers
- ✅ Setup swap memory (2GB)
- ✅ Create Wings management script
- ✅ Port configuration (8080, 2022, 25565-25665)

### **MENU INTERAKTIF:**

#### 5. **quick-start.sh** - Menu Original (Panel Only)
Menu user-friendly untuk operasi Panel:
- 🚀 Install Pterodactyl Panel
- ⚡ Optimize Existing Panel
- 📊 Check Panel Status & Monitoring
- 🔄 Update Pterodactyl Panel
- 💾 Backup Panel & Database
- 🔧 Troubleshooting & Repair
- 📖 View Documentation

#### 6. **quick-start-v2.sh** - Menu V2 (Panel + Wings) 🆕 RECOMMENDED!
Menu terintegrasi untuk Panel & Wings:
- **PANEL:**
  - [1] 🚀 Install Pterodactyl Panel
  - [2] ⚡ Optimize Panel
  - [3] 🔄 Update Panel
- **WINGS:**
  - [4] 🦅 Install Wings (Daemon/Node)
  - [5] 🔧 Manage Wings (Start/Stop/Restart)
  - [6] 📝 Configure Wings
- **MONITORING:**
  - [7] 📊 Check System Status (Panel + Wings)
  - [8] 💾 Backup Panel & Database
  - [9] 🔧 Troubleshooting & Repair
- **OTHER:**
  - [10] 📖 View Documentation
  - [11] ❌ Exit

### **DOKUMENTASI:**

#### 7. **README.md** - Dokumentasi Utama
Dokumentasi lengkap semua fitur

#### 8. **CARA-INSTALASI.md** - Panduan Instalasi Panel
Panduan step-by-step instalasi Panel:
- Metode instalasi otomatis (recommended)
- Metode instalasi manual
- Verifikasi instalasi
- Troubleshooting
- Langkah selanjutnya

#### 9. **WINGS-INSTALLATION.md** - Panduan Instalasi Wings 🆕
Panduan lengkap instalasi Wings:
- Persyaratan sistem
- Instalasi otomatis & manual
- Konfigurasi Wings
- Management Wings
- Troubleshooting Wings
- Optimasi game servers

#### 10. **TROUBLESHOOTING.md** - Panduan Troubleshooting
Solusi lengkap untuk masalah umum Panel & Wings:
- ❌ Application Key errors
- ❌ MySQL Access Denied (ERROR 1045)
- ❌ Database Connection Failed
- ❌ Composer Install Failed
- ❌ Permission Denied
- ❌ 502 Bad Gateway
- ❌ SSL Certificate Failed
- ❌ Queue Worker issues
- ❌ Migration Failed
- ❌ Wings connection issues
- 🔍 Diagnostic commands

---

## 🚀 Quick Start

### Persyaratan Sistem

**Untuk Panel:**
- Ubuntu 24.04 LTS (fresh install recommended)
- Minimal 2GB RAM (4GB+ recommended)
- Minimal 20GB disk space
- Domain yang sudah pointing ke server
- Akses root/sudo

**Untuk Wings:**
- Ubuntu 24.04 LTS
- Minimal 2GB RAM (4GB+ recommended untuk game servers)
- Minimal 20GB disk space (tergantung jumlah servers)
- Domain/subdomain untuk Wings (optional)
- Panel sudah terinstall dan berjalan

### Instalasi Tercepat (All-in-One)

#### **Metode 1: Download dari GitHub (RECOMMENDED)**

```bash
# Login ke server
ssh root@your-server-ip

# Masuk ke direktori root
cd /root

# Download semua script dari GitHub
wget https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/pterodactyl-installer.sh
wget https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/pterodactyl-optimizer.sh
wget https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/wings-installer.sh
wget https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/fix-common-issues.sh
wget https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/quick-start.sh
wget https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/quick-start-v2.sh

# Download dokumentasi (optional)
wget https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/README.md
wget https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/CARA-INSTALASI.md
wget https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/WINGS-INSTALLATION.md
wget https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/TROUBLESHOOTING.md

# Berikan permission
chmod +x *.sh

# Jalankan menu V2 (Panel + Wings)
sudo bash quick-start-v2.sh
```

**Catatan:** Ganti `YOUR_USERNAME` dan `YOUR_REPO` dengan username dan repository GitHub Anda.

#### **Metode 2: Download Semua Sekaligus (One-Liner)**

```bash
# Download dan setup otomatis
cd /root && \
wget -q https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/pterodactyl-installer.sh && \
wget -q https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/pterodactyl-optimizer.sh && \
wget -q https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/wings-installer.sh && \
wget -q https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/fix-common-issues.sh && \
wget -q https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/quick-start.sh && \
wget -q https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/quick-start-v2.sh && \
chmod +x *.sh && \
echo "✓ Download selesai! Jalankan: sudo bash quick-start-v2.sh"
```

#### **Metode 3: Upload Manual (SCP)**

```bash
# Upload semua script ke server
scp *.sh *.md root@your-server-ip:/root/

# Login ke server
ssh root@your-server-ip

# Berikan permission
cd /root
chmod +x *.sh

# Jalankan menu V2 (Panel + Wings)
sudo bash quick-start-v2.sh
```

#### **Metode 4: Clone Repository**

```bash
# Login ke server
ssh root@your-server-ip

# Clone repository
cd /root
git clone https://github.com/lutfialifofc-droid/fully-for-pterodactyl.git
cd YOUR_REPO

# Berikan permission
chmod +x *.sh

# Jalankan menu V2
sudo bash quick-start-v2.sh
```

### Skenario Instalasi

#### **Skenario 1: Server Terpisah (RECOMMENDED untuk Production)**

**Server 1 - Panel:**
```bash
sudo bash quick-start-v2.sh
# Pilih [1] Install Pterodactyl Panel
# Tunggu selesai
# Pilih [2] Optimize Panel (optional)
```

**Server 2 - Wings/Node:**
```bash
sudo bash quick-start-v2.sh
# Pilih [4] Install Wings
# Konfigurasi Wings dari Panel
# Pilih [6] Configure Wings
```

#### **Skenario 2: Server Sama (Testing/Development)**

```bash
sudo bash quick-start-v2.sh
# Pilih [1] Install Panel
# Tunggu selesai
# Pilih [4] Install Wings
# Konfigurasi Wings
```

#### **Skenario 3: Panel Only**

```bash
sudo bash quick-start.sh
# Pilih [1] Install Pterodactyl Panel
```

#### **Skenario 4: Wings Only**

```bash
chmod +x wings-installer.sh
sudo bash wings-installer.sh
```

---

## 🦅 Instalasi Wings (Daemon/Node)

### Langkah Lengkap:

#### 1. Install Wings di Server
```bash
sudo bash quick-start-v2.sh
# Pilih [4] Install Wings
```

**Installer akan meminta:**
- Panel URL (contoh: https://panel.example.com)
- FQDN untuk node (contoh: node1.example.com)

#### 2. Buat Node di Panel
1. Login ke Panel sebagai admin
2. **Admin Panel** → **Nodes** → **Create New**
3. Isi informasi node
4. Pergi ke tab **Configuration**
5. Copy konfigurasi yang ditampilkan

#### 3. Paste Konfigurasi ke Server
```bash
sudo bash quick-start-v2.sh
# Pilih [6] Configure Wings
# Paste konfigurasi dari Panel
```

#### 4. Start Wings
```bash
sudo bash quick-start-v2.sh
# Pilih [5] Manage Wings → [1] Start Wings
```

#### 5. Verifikasi
- Check di Panel: Node harus online (heartbeat hijau)
- Check di server: `systemctl status wings`

**📖 Untuk panduan lengkap Wings, baca [WINGS-INSTALLATION.md](WINGS-INSTALLATION.md)**

---

## ⚡ Optimasi Panel Existing

```bash
sudo bash pterodactyl-optimizer.sh
```

Script akan otomatis:
- Membuat backup konfigurasi
- Mendeteksi resource sistem (RAM, CPU)
- Mengoptimalkan PHP-FPM, Nginx, MariaDB, Redis
- Restart services
- Generate laporan optimasi

---

## 📊 Monitoring & Management

### Check Status (Panel + Wings)

```bash
sudo bash quick-start-v2.sh
# Pilih [7] Check System Status
```

Output menampilkan:
- Status Panel services (Nginx, PHP-FPM, MariaDB, Redis, Queue)
- Status Wings service & Docker
- Resource usage (CPU, RAM, Disk)
- Running containers

### Wings Management

**Menggunakan Menu:**
```bash
sudo bash quick-start-v2.sh
# Pilih [5] Manage Wings
```

**Menggunakan Wings Manager:**
```bash
wings-manager.sh start      # Start Wings
wings-manager.sh stop       # Stop Wings
wings-manager.sh restart    # Restart Wings
wings-manager.sh status     # Check status
wings-manager.sh logs       # View logs
wings-manager.sh update     # Update Wings
```

**Manual Commands:**
```bash
systemctl start wings       # Start
systemctl stop wings        # Stop
systemctl restart wings     # Restart
systemctl status wings      # Status
journalctl -u wings -f      # Logs
```

---

## 🔧 Troubleshooting & Fix

### Mengalami Error?

**Gunakan Fix Script:**
```bash
sudo bash fix-common-issues.sh
```

**Atau melalui menu:**
```bash
sudo bash quick-start-v2.sh
# Pilih [9] Troubleshooting & Repair
```

### Masalah Umum Panel:

#### ❌ ERROR: Application Key Not Set
```bash
sudo bash fix-common-issues.sh
# Pilih [1] Fix Application Key
```

#### ❌ ERROR 1045: MySQL Access Denied
```bash
sudo bash fix-common-issues.sh
# Pilih [2] Fix MySQL Access Denied
```

#### ❌ Database Connection Failed
```bash
sudo bash fix-common-issues.sh
# Pilih [3] Fix Database Connection
```

### Masalah Umum Wings:

#### ❌ Wings Offline di Panel
```bash
# Check Wings service
systemctl status wings

# Check firewall
ufw allow 8080/tcp

# Restart Wings
systemctl restart wings
```

#### ❌ Server Tidak Start
```bash
# Check Wings logs
journalctl -u wings -f

# Check Docker
docker ps -a
```

**📖 Untuk panduan lengkap, baca [TROUBLESHOOTING.md](TROUBLESHOOTING.md)**

---

## 🎯 Ports yang Digunakan

### Panel:
- **80/tcp** - HTTP (redirect ke HTTPS)
- **443/tcp** - HTTPS (Panel access)
- **22/tcp** - SSH

### Wings:
- **8080/tcp** - Wings API
- **2022/tcp** - SFTP
- **25565-25665/tcp & udp** - Game servers (default range)

### Firewall Configuration:
```bash
# Panel
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp

# Wings
ufw allow 8080/tcp
ufw allow 2022/tcp
ufw allow 25565:25665/tcp
ufw allow 25565:25665/udp
```

---

## 🔄 Update

### Update Panel:
```bash
sudo bash quick-start-v2.sh
# Pilih [3] Update Panel
```

### Update Wings:
```bash
sudo bash quick-start-v2.sh
# Pilih [5] Manage Wings → [6] Update Wings
```

---

## 💾 Backup & Restore

### Backup Panel & Database:
```bash
sudo bash quick-start-v2.sh
# Pilih [8] Backup Panel & Database
```

### Manual Backup:
```bash
# Create backup directory
mkdir -p /root/backups/$(date +%Y%m%d)

# Backup Panel files
tar -czf /root/backups/$(date +%Y%m%d)/panel-files.tar.gz /var/www/pterodactyl

# Backup database
mysqldump -u root -p panel > /root/backups/$(date +%Y%m%d)/panel-db.sql

# Backup Wings config
cp /etc/pterodactyl/config.yml /root/backups/$(date +%Y%m%d)/
```

---

## 🆕 What's New

### Version 2.0.0 (Latest) - Wings Support! 🦅
- 🦅 **NEW**: wings-installer.sh - Auto installer untuk Wings/Daemon
- 🦅 **NEW**: quick-start-v2.sh - Menu terintegrasi Panel + Wings
- 🦅 **NEW**: WINGS-INSTALLATION.md - Panduan lengkap Wings
- 🦅 **NEW**: Wings management script (start/stop/restart/update)
- ⚡ **IMPROVED**: System status monitoring (Panel + Wings)
- ⚡ **IMPROVED**: Backup script (include Wings config)
- ⚡ **IMPROVED**: Troubleshooting menu (Panel + Wings)

### Version 1.1.0 - Bug Fixes & Improvements
- 🔧 **FIXED**: Application Key generation & verification
- 🔧 **FIXED**: MySQL Access Denied (ERROR 1045)
- 🔧 **FIXED**: MariaDB service start sebelum konfigurasi
- ✨ **NEW**: fix-common-issues.sh
- ✨ **NEW**: TROUBLESHOOTING.md
- ✨ **NEW**: CARA-INSTALASI.md
- ✨ **NEW**: quick-start.sh

### Version 1.0.0 - Initial Release
- Initial release
- Auto installer untuk Ubuntu 24.04 LTS
- Optimizer dengan deteksi resource otomatis
- Monitoring script

---

## 📚 Dokumentasi Lengkap

- **[README.md](README.md)** - Dokumentasi utama (file ini)
- **[CARA-INSTALASI.md](CARA-INSTALASI.md)** - Panduan instalasi Panel step-by-step
- **[WINGS-INSTALLATION.md](WINGS-INSTALLATION.md)** - Panduan instalasi Wings lengkap 🆕
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Solusi untuk semua masalah umum

---

## 💡 Tips & Best Practices

1. **Gunakan server terpisah** - Panel dan Wings di server berbeda untuk production
2. **Selalu backup** - Sebelum update atau perubahan besar
3. **Gunakan domain valid** - Jangan gunakan IP address
4. **Setup email** - Penting untuk notifikasi
5. **Monitor resource** - Gunakan monitoring tools
6. **Update berkala** - Panel dan Wings
7. **Password kuat** - Database dan admin user
8. **Enable 2FA** - Keamanan tambahan
9. **SSL certificate** - Untuk Panel dan Wings
10. **Firewall** - Hanya buka port yang diperlukan

---

## ❓ FAQ

### Q: Apakah Panel dan Wings harus di server terpisah?
**A:** Tidak wajib, tapi sangat direkomendasikan untuk production. Bisa di server sama untuk testing.

### Q: Berapa resource yang dibutuhkan?
**A:** Panel: 2GB RAM minimum. Wings: 2GB+ RAM tergantung jumlah game servers.

### Q: Apakah script ini gratis?
**A:** Ya, 100% gratis dan open source (MIT License).

### Q: Support Ubuntu versi lain?
**A:** Dioptimalkan untuk Ubuntu 24.04 LTS, mungkin bisa di versi lain dengan modifikasi.

### Q: Bagaimana cara menambah game server?
**A:** Buat server baru di Panel, Wings akan otomatis handle deployment.

### Q: Apakah bisa multiple Wings?
**A:** Ya, bisa install Wings di multiple server dan register sebagai node berbeda di Panel.

### Q: Bagaimana cara update?
**A:** Gunakan menu update di quick-start-v2.sh untuk Panel dan Wings.

---

## 🤝 Kontribusi

Kontribusi sangat diterima! 

1. Fork repository
2. Buat branch baru (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

---

## 📞 Support

Jika mengalami masalah:

1. **Baca dokumentasi:**
   - [CARA-INSTALASI.md](CARA-INSTALASI.md) - Panel
   - [WINGS-INSTALLATION.md](WINGS-INSTALLATION.md) - Wings
   - [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Troubleshooting

2. **Gunakan fix script:**
   ```bash
   sudo bash fix-common-issues.sh
   ```

3. **Check logs:**
   ```bash
   # Panel
   sudo tail -f /var/log/nginx/pterodactyl.app-error.log
   
   # Wings
   sudo journalctl -u wings -f
   ```

4. **Join komunitas:**
   - Discord Pterodactyl: https://discord.gg/pterodactyl
   - Dokumentasi Resmi: https://pterodactyl.io

---

## ⚠️ Disclaimer

Script ini disediakan "as is" tanpa warranty. Selalu backup data sebelum menjalankan script. Penulis tidak bertanggung jawab atas kerusakan atau kehilangan data.

---

## 📄 License

MIT License - Copyright (c) 2024

---

## 🙏 Credits & Acknowledgments

- **Pterodactyl Panel**: https://pterodactyl.io
- **Ubuntu**: https://ubuntu.com
- **Nginx**: https://nginx.org
- **PHP**: https://php.net
- **MariaDB**: https://mariadb.org
- **Redis**: https://redis.io
- **Docker**: https://docker.com
- **Let's Encrypt**: https://letsencrypt.org

Dibuat dengan ❤️ untuk komunitas Pterodactyl Indonesia

---

## 🌟 Star History

Jika script ini membantu Anda, berikan ⭐ di GitHub!

---

## 📚 Referensi

- [Pterodactyl Panel Docs](https://pterodactyl.io/panel/1.0/getting_started.html)
- [Pterodactyl Wings Docs](https://pterodactyl.io/wings/1.0/installing.html)
- [Docker Documentation](https://docs.docker.com/)
- [Nginx Optimization](https://www.nginx.com/blog/tuning-nginx/)
- [PHP-FPM Tuning](https://www.php.net/manual/en/install.fpm.configuration.php)
- [MariaDB Performance](https://mariadb.com/kb/en/optimization-and-tuning/)

---

**🚀 Selamat menggunakan! Semoga server Pterodactyl Anda berjalan lancar!**

**🦅 Wings ready! Siap menjalankan game servers!**

**📖 Butuh bantuan? Baca dokumentasi atau join Discord Pterodactyl!**


