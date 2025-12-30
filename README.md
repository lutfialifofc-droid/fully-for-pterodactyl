# Pterodactyl Panel Auto Installer & Optimizer
## Ubuntu 24.04 LTS + Nginx

Script lengkap untuk instalasi dan optimasi Pterodactyl Panel dengan performa maksimal.

**🆕 UPDATE: Script telah diperbaiki untuk mengatasi masalah Application Key dan MySQL Access Denied!**

---

## 📦 Daftar Script

### 1. **pterodactyl-installer.sh** - Auto Installer ⭐ UPDATED
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

### 2. **pterodactyl-optimizer.sh** - Optimizer
- ✅ Optimasi PHP-FPM berdasarkan RAM sistem
- ✅ Optimasi Nginx dengan worker processes dinamis
- ✅ Tuning MariaDB/MySQL untuk performa maksimal
- ✅ Konfigurasi Redis dengan memory management
- ✅ Kernel parameter optimization
- ✅ FastCGI caching
- ✅ OPcache configuration
- ✅ Monitoring script
- ✅ Automatic backup sebelum optimasi

### 3. **quick-start.sh** - Menu Interaktif 🎯
Menu user-friendly untuk semua operasi:
- 🚀 Install Pterodactyl Panel
- ⚡ Optimize Existing Panel
- 📊 Check Panel Status & Monitoring
- 🔄 Update Pterodactyl Panel
- 💾 Backup Panel & Database
- 🔧 Troubleshooting & Repair
- 📖 View Documentation

### 4. **fix-common-issues.sh** - Fix Script 🆕 NEW!
Script khusus untuk memperbaiki masalah umum:
- [1] Fix Application Key (APP_KEY empty/not set)
- [2] Fix MySQL Access Denied (ERROR 1045)
- [3] Fix Database Connection Issues
- [4] Fix All Permissions
- [5] Complete System Check & Fix

### 5. **CARA-INSTALASI.md** - Panduan Instalasi 📖
Panduan lengkap step-by-step:
- Metode instalasi otomatis (recommended)
- Metode instalasi manual
- Verifikasi instalasi
- Troubleshooting
- Langkah selanjutnya

### 6. **TROUBLESHOOTING.md** - Panduan Troubleshooting 🔧 NEW!
Solusi lengkap untuk masalah umum:
- ❌ Application Key errors
- ❌ MySQL Access Denied (ERROR 1045)
- ❌ Database Connection Failed
- ❌ Composer Install Failed
- ❌ Permission Denied
- ❌ 502 Bad Gateway
- ❌ SSL Certificate Failed
- ❌ Queue Worker issues
- ❌ Migration Failed
- 🔍 Diagnostic commands

---

## 🚀 Quick Start

### Persyaratan Sistem
- Ubuntu 24.04 LTS (fresh install recommended)
- Minimal 2GB RAM (4GB+ recommended)
- Minimal 20GB disk space
- Domain yang sudah pointing ke server
- Akses root/sudo

### Instalasi Tercepat (Menggunakan Menu Interaktif)

1. **Upload semua script ke server:**
```bash
scp pterodactyl-installer.sh root@your-server-ip:/root/
scp pterodactyl-optimizer.sh root@your-server-ip:/root/
scp quick-start.sh root@your-server-ip:/root/
scp fix-common-issues.sh root@your-server-ip:/root/
```

2. **Login ke server:**
```bash
ssh root@your-server-ip
```

3. **Berikan permission:**
```bash
cd /root
chmod +x *.sh
```

4. **Jalankan menu interaktif:**
```bash
sudo bash quick-start.sh
```

5. **Pilih opsi [1] Install Pterodactyl Panel**

6. **Ikuti prompt yang muncul:**
   - Masukkan domain (contoh: panel.example.com)
   - Masukkan email untuk Let's Encrypt
   - Buat password MySQL root
   - Buat password database Pterodactyl
   - Pilih timezone (contoh: Asia/Jakarta)

7. **Tunggu proses instalasi selesai** (±10-15 menit)

8. **Akses panel Anda:**
   - URL: https://your-domain.com
   - Setup admin user sesuai instruksi

### Instalasi Manual (Tanpa Menu)

```bash
# Download dan jalankan installer langsung
chmod +x pterodactyl-installer.sh
sudo bash pterodactyl-installer.sh
```

**📖 Untuk panduan lengkap, baca [CARA-INSTALASI.md](CARA-INSTALASI.md)**

---

## ⚡ Optimasi Panel Existing

Jika Anda sudah memiliki Pterodactyl Panel yang terinstall:

### Langkah Optimasi

1. **Download script optimizer:**
```bash
cd /root
chmod +x pterodactyl-optimizer.sh
```

2. **Jalankan optimizer:**
```bash
sudo bash pterodactyl-optimizer.sh
```

3. **Script akan otomatis:**
   - Membuat backup konfigurasi existing
   - Mendeteksi resource sistem (RAM, CPU)
   - Mengoptimalkan semua komponen
   - Restart services yang diperlukan
   - Generate laporan optimasi

4. **Reboot server (recommended):**
```bash
sudo reboot
```

---

## 📊 Monitoring & Maintenance

### Check Status Panel
```bash
pterodactyl-monitor.sh
```

Output akan menampilkan:
- Status semua services (Nginx, PHP-FPM, MariaDB, Redis, Queue Worker)
- Resource usage (CPU, RAM, Disk)
- PHP-FPM pool status
- Recent errors

### View Optimization Report
```bash
cat /root/pterodactyl-optimization-report.txt
```

### Manual Service Management

**Restart semua services:**
```bash
sudo systemctl restart php8.2-fpm nginx mariadb redis-server pteroq
```

**Check individual service:**
```bash
sudo systemctl status php8.2-fpm
sudo systemctl status nginx
sudo systemctl status mariadb
sudo systemctl status redis-server
sudo systemctl status pteroq
```

**View logs:**
```bash
# Nginx error log
sudo tail -f /var/log/nginx/pterodactyl.app-error.log

# Nginx access log
sudo tail -f /var/log/nginx/pterodactyl.app-access.log

# PHP-FPM error log
sudo tail -f /var/log/php8.2-fpm-error.log

# PHP-FPM slow log
sudo tail -f /var/log/php8.2-fpm-slow.log

# Queue worker log
sudo journalctl -u pteroq -f
```

---

## 🔧 Troubleshooting & Fix

### Mengalami Error Saat Instalasi?

**Gunakan Fix Script:**
```bash
sudo bash fix-common-issues.sh
```

### Masalah Umum & Solusi Cepat:

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

#### ❌ Permission Errors
```bash
sudo bash fix-common-issues.sh
# Pilih [4] Fix All Permissions
```

#### 🔍 Complete System Check
```bash
sudo bash fix-common-issues.sh
# Pilih [5] Complete System Check & Fix
```

### Troubleshooting Manual

**Panel tidak bisa diakses:**
```bash
sudo systemctl status nginx php8.2-fpm
sudo tail -f /var/log/nginx/pterodactyl.app-error.log
```

**Queue Worker tidak berjalan:**
```bash
sudo systemctl status pteroq
sudo systemctl restart pteroq
sudo journalctl -u pteroq -n 50
```

**Database connection error:**
```bash
mysql -u pterodactyl -p panel
sudo systemctl status mariadb
```

**📖 Untuk panduan lengkap troubleshooting, baca [TROUBLESHOOTING.md](TROUBLESHOOTING.md)**

---

## 🔧 Konfigurasi Manual

### Lokasi File Konfigurasi

**Pterodactyl:**
- Panel: `/var/www/pterodactyl/`
- Environment: `/var/www/pterodactyl/.env`

**Nginx:**
- Main config: `/etc/nginx/nginx.conf`
- Site config: `/etc/nginx/sites-available/pterodactyl.conf`

**PHP-FPM:**
- Pool config: `/etc/php/8.2/fpm/pool.d/www.conf`
- PHP.ini: `/etc/php/8.2/fpm/php.ini`

**MariaDB:**
- Config: `/etc/mysql/mariadb.conf.d/99-pterodactyl.cnf`

**Redis:**
- Config: `/etc/redis/redis.conf`

### Update Pterodactyl Panel

```bash
cd /var/www/pterodactyl
php artisan down

# Backup
cp .env .env.backup

# Update
curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv
chmod -R 755 storage/* bootstrap/cache

# Update dependencies
COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader

# Update database
php artisan migrate --seed --force

# Clear cache
php artisan view:clear
php artisan config:clear
php artisan cache:clear

# Optimize
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Set permissions
chown -R www-data:www-data /var/www/pterodactyl/*

php artisan up
```

---

## 🎯 Optimasi Berdasarkan RAM

Script optimizer akan otomatis menyesuaikan konfigurasi berdasarkan RAM:

### < 2GB RAM (VPS Kecil)
- PHP-FPM max children: 25
- Nginx worker connections: 1024
- MySQL InnoDB buffer: 256M
- Redis max memory: 128MB

### 2-4GB RAM (VPS Medium)
- PHP-FPM max children: 50
- Nginx worker connections: 2048
- MySQL InnoDB buffer: 512M
- Redis max memory: 256MB

### 4-8GB RAM (VPS Large)
- PHP-FPM max children: 100
- Nginx worker connections: 4096
- MySQL InnoDB buffer: 1G
- Redis max memory: 512MB

### > 8GB RAM (Dedicated/High-End)
- PHP-FPM max children: 150
- Nginx worker connections: 8192
- MySQL InnoDB buffer: 2G
- Redis max memory: 1GB

---

## 🔒 Keamanan

### Firewall Rules (UFW)
```bash
sudo ufw status
```

Default ports yang dibuka:
- 22/tcp (SSH)
- 80/tcp (HTTP)
- 443/tcp (HTTPS)
- 8080/tcp (Wings/Daemon)
- 2022/tcp (SFTP)

### SSL Certificate Renewal

Let's Encrypt certificates akan auto-renew. Untuk manual renewal:
```bash
sudo certbot renew
sudo systemctl reload nginx
```

### Database Security

Ganti password database:
```bash
mysql -u root -p
ALTER USER 'pterodactyl'@'127.0.0.1' IDENTIFIED BY 'new_password';
FLUSH PRIVILEGES;
EXIT;

# Update .env file
nano /var/www/pterodactyl/.env
# Ubah DB_PASSWORD
```

---

## 📈 Performance Tips

1. **Enable OPcache** (sudah enabled by optimizer)
2. **Use Redis for sessions** (sudah configured)
3. **Enable FastCGI cache** (sudah configured)
4. **Regular database optimization:**
```bash
mysqlcheck -u root -p --auto-repair --optimize --all-databases
```

5. **Monitor slow queries:**
```bash
sudo tail -f /var/log/mysql/mysql-slow.log
```

6. **Clear old logs:**
```bash
sudo find /var/log -type f -name "*.log" -mtime +30 -delete
```

---

## 🔄 Backup & Restore

### Manual Backup

**Full backup:**
```bash
# Create backup directory
mkdir -p /root/backups/$(date +%Y%m%d)

# Backup files
tar -czf /root/backups/$(date +%Y%m%d)/pterodactyl-files.tar.gz /var/www/pterodactyl

# Backup database
mysqldump -u root -p panel > /root/backups/$(date +%Y%m%d)/pterodactyl-db.sql

# Backup configs
cp /var/www/pterodactyl/.env /root/backups/$(date +%Y%m%d)/
cp /etc/nginx/sites-available/pterodactyl.conf /root/backups/$(date +%Y%m%d)/
```

### Automated Backup Script

```bash
cat > /usr/local/bin/pterodactyl-backup.sh <<'EOF'
#!/bin/bash
BACKUP_DIR="/root/backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p $BACKUP_DIR

# Backup files
tar -czf $BACKUP_DIR/pterodactyl-files.tar.gz /var/www/pterodactyl

# Backup database
mysqldump -u root -p$(grep DB_PASSWORD /var/www/pterodactyl/.env | cut -d '=' -f2) panel > $BACKUP_DIR/pterodactyl-db.sql

# Keep only last 7 days
find /root/backups -type d -mtime +7 -exec rm -rf {} +

echo "Backup completed: $BACKUP_DIR"
EOF

chmod +x /usr/local/bin/pterodactyl-backup.sh

# Add to crontab (daily at 2 AM)
(crontab -l 2>/dev/null; echo "0 2 * * * /usr/local/bin/pterodactyl-backup.sh") | crontab -
```

### Restore from Backup

```bash
# Stop services
sudo systemctl stop nginx php8.2-fpm pteroq

# Restore files
cd /var/www
sudo rm -rf pterodactyl
sudo tar -xzf /root/backups/YYYYMMDD/pterodactyl-files.tar.gz

# Restore database
mysql -u root -p panel < /root/backups/YYYYMMDD/pterodactyl-db.sql

# Set permissions
sudo chown -R www-data:www-data /var/www/pterodactyl

# Start services
sudo systemctl start nginx php8.2-fpm pteroq
```

---

## 🆕 What's New

### Version 1.1.0 (Latest) - Bug Fixes & Improvements
- 🔧 **FIXED**: Application Key generation & verification
- 🔧 **FIXED**: MySQL Access Denied (ERROR 1045) dengan multiple fallback methods
- 🔧 **FIXED**: MariaDB service start sebelum konfigurasi
- ✨ **NEW**: fix-common-issues.sh - Script untuk fix masalah umum
- ✨ **NEW**: TROUBLESHOOTING.md - Panduan troubleshooting lengkap
- ✨ **NEW**: CARA-INSTALASI.md - Panduan instalasi step-by-step
- ✨ **NEW**: quick-start.sh - Menu interaktif user-friendly
- ⚡ **IMPROVED**: Error handling yang lebih baik
- ⚡ **IMPROVED**: Verifikasi setiap step instalasi
- ⚡ **IMPROVED**: Dokumentasi yang lebih lengkap

### Version 1.0.0 (2024)
- Initial release
- Auto installer untuk Ubuntu 24.04 LTS
- Optimizer dengan deteksi resource otomatis
- Monitoring script
- Comprehensive documentation

---

## 📚 Dokumentasi Lengkap

- **[CARA-INSTALASI.md](CARA-INSTALASI.md)** - Panduan instalasi step-by-step lengkap
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Solusi untuk semua masalah umum
- **[README.md](README.md)** - Dokumentasi utama (file ini)

---

## 💡 Tips & Best Practices

1. **Selalu backup sebelum update atau perubahan besar**
2. **Gunakan domain yang valid** - Jangan gunakan IP address
3. **Setup email dengan benar** - Penting untuk notifikasi
4. **Monitor resource usage** - Gunakan pterodactyl-monitor.sh
5. **Update secara berkala** - Gunakan menu update di quick-start.sh
6. **Gunakan password yang kuat** - Untuk database dan admin user
7. **Enable 2FA** - Untuk keamanan tambahan
8. **Jalankan optimizer setelah instalasi** - Untuk performa optimal

---

## ❓ FAQ

### Q: Bagaimana cara menggunakan script ini?
**A:** Upload semua script ke server, berikan permission dengan `chmod +x *.sh`, lalu jalankan `sudo bash quick-start.sh`

### Q: Apakah script ini gratis?
**A:** Ya, 100% gratis dan open source (MIT License)

### Q: Apakah bisa digunakan untuk production?
**A:** Ya, script ini dirancang untuk production environment dengan best practices

### Q: Bagaimana jika instalasi gagal?
**A:** Gunakan `fix-common-issues.sh` atau baca `TROUBLESHOOTING.md` untuk solusi

### Q: Apakah support Ubuntu versi lain?
**A:** Script ini dioptimalkan untuk Ubuntu 24.04 LTS, tapi mungkin bisa berjalan di versi lain dengan modifikasi

### Q: Bagaimana cara update panel?
**A:** Jalankan `sudo bash quick-start.sh` dan pilih opsi [4] Update Pterodactyl Panel

### Q: Apakah ada support untuk Wings (Daemon)?
**A:** Script ini hanya untuk Panel. Untuk Wings, ikuti dokumentasi resmi Pterodactyl

---

## 🤝 Kontribusi

Kontribusi sangat diterima! Jika Anda ingin berkontribusi:

1. Fork repository ini
2. Buat branch baru (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

---

## 📞 Support

Jika mengalami masalah:

1. **Baca dokumentasi:**
   - [CARA-INSTALASI.md](CARA-INSTALASI.md)
   - [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

2. **Gunakan fix script:**
   ```bash
   sudo bash fix-common-issues.sh
   ```

3. **Check logs:**
   ```bash
   sudo tail -f /var/log/nginx/pterodactyl.app-error.log
   ```

4. **Join komunitas:**
   - Discord Pterodactyl: https://discord.gg/pterodactyl
   - Dokumentasi Resmi: https://pterodactyl.io

---

## ⚠️ Disclaimer

Script ini disediakan "as is" tanpa warranty. Selalu backup data Anda sebelum menjalankan script. Penulis tidak bertanggung jawab atas kerusakan atau kehilangan data yang mungkin terjadi.

---

## 📄 License

MIT License

Copyright (c) 2024

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

## 🙏 Credits & Acknowledgments

- **Pterodactyl Panel**: https://pterodactyl.io - Amazing game server management panel
- **Ubuntu**: https://ubuntu.com - Reliable Linux distribution
- **Nginx**: https://nginx.org - High-performance web server
- **PHP**: https://php.net - Server-side scripting language
- **MariaDB**: https://mariadb.org - Robust database server
- **Redis**: https://redis.io - In-memory data structure store
- **Let's Encrypt**: https://letsencrypt.org - Free SSL certificates

Dibuat dengan ❤️ untuk komunitas Pterodactyl Indonesia

---

## 🌟 Star History

Jika script ini membantu Anda, berikan ⭐ di GitHub!

---

## 📚 Referensi Tambahan

- [Pterodactyl Documentation](https://pterodactyl.io/panel/1.0/getting_started.html)
- [Nginx Optimization Guide](https://www.nginx.com/blog/tuning-nginx/)
- [PHP-FPM Tuning](https://www.php.net/manual/en/install.fpm.configuration.php)
- [MariaDB Performance](https://mariadb.com/kb/en/optimization-and-tuning/)

---

**Selamat menggunakan! Semoga server Pterodactyl Anda berjalan lancar! 🚀**

**Butuh bantuan? Baca [TROUBLESHOOTING.md](TROUBLESHOOTING.md) atau jalankan `sudo bash fix-common-issues.sh`**
