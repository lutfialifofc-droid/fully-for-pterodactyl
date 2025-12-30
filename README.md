# Pterodactyl Panel Auto Installer & Optimizer
## Ubuntu 24.04 LTS + Nginx

Script lengkap untuk instalasi dan optimasi Pterodactyl Panel dengan performa maksimal.

---

## 📋 Fitur

### Auto Installer (`pterodactyl-installer.sh`)
- ✅ Instalasi otomatis Pterodactyl Panel versi terbaru
- ✅ Konfigurasi PHP 8.2 dengan ekstensi lengkap
- ✅ Setup MariaDB dengan keamanan optimal
- ✅ Konfigurasi Redis untuk caching
- ✅ Setup Nginx dengan SSL (Let's Encrypt)
- ✅ Konfigurasi Queue Worker otomatis
- ✅ Firewall configuration (UFW)
- ✅ Cron jobs untuk scheduled tasks

### Optimizer (`pterodactyl-optimizer.sh`)
- ✅ Optimasi PHP-FPM berdasarkan RAM sistem
- ✅ Optimasi Nginx dengan worker processes dinamis
- ✅ Tuning MariaDB/MySQL untuk performa maksimal
- ✅ Konfigurasi Redis dengan memory management
- ✅ Kernel parameter optimization
- ✅ FastCGI caching
- ✅ OPcache configuration
- ✅ Monitoring script
- ✅ Automatic backup sebelum optimasi

---

## 🚀 Instalasi Baru

### Persyaratan Sistem
- Ubuntu 24.04 LTS (fresh install recommended)
- Minimal 2GB RAM (4GB+ recommended)
- Minimal 20GB disk space
- Domain yang sudah pointing ke server
- Akses root/sudo

### Langkah Instalasi

1. **Download script installer:**
```bash
wget https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/pterodactyl-installer.sh
wget https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/pterodactyl-optimizer.sh
wget https://raw.githubusercontent.com/lutfialifofc-droid/fully-for-pterodactyl/main/quick-start.sh
chmod +x pterodactyl-installer.sh
```

2. **Jalankan installer:**
```bash
sudo bash pterodactyl-installer.sh
```

3. **Ikuti prompt yang muncul:**
   - Masukkan domain (contoh: panel.example.com)
   - Masukkan email untuk Let's Encrypt
   - Buat password MySQL root
   - Buat password database Pterodactyl
   - Pilih timezone (contoh: Asia/Jakarta)

4. **Tunggu proses instalasi selesai** (±10-15 menit)

5. **Akses panel Anda:**
   - URL: https://your-domain.com
   - Setup admin user sesuai instruksi

---

## ⚡ Optimasi Panel Existing

Jika Anda sudah memiliki Pterodactyl Panel yang terinstall:

### Langkah Optimasi

1. **Download script optimizer:**
```bash
cd /root
wget https://raw.githubusercontent.com/yourusername/pterodactyl-scripts/main/pterodactyl-optimizer.sh
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

## 🐛 Troubleshooting

### Panel tidak bisa diakses

1. **Check Nginx:**
```bash
sudo nginx -t
sudo systemctl status nginx
```

2. **Check PHP-FPM:**
```bash
sudo systemctl status php8.2-fpm
```

3. **Check logs:**
```bash
sudo tail -f /var/log/nginx/pterodactyl.app-error.log
```

### Queue Worker tidak berjalan

```bash
sudo systemctl status pteroq
sudo systemctl restart pteroq
sudo journalctl -u pteroq -n 50
```

### Database connection error

```bash
# Test connection
mysql -u pterodactyl -p panel

# Check MariaDB status
sudo systemctl status mariadb

# Restart MariaDB
sudo systemctl restart mariadb
```

### High CPU/RAM usage

```bash
# Check processes
top
htop

# Check PHP-FPM pool
sudo systemctl status php8.2-fpm

# Adjust PHP-FPM settings
sudo nano /etc/php/8.2/fpm/pool.d/www.conf
# Kurangi pm.max_children jika perlu
sudo systemctl restart php8.2-fpm
```

### Permission errors

```bash
cd /var/www/pterodactyl
sudo chown -R www-data:www-data *
sudo chmod -R 755 storage bootstrap/cache
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

## 📞 Support & Kontribusi

### Melaporkan Issues
Jika menemukan bug atau masalah, silakan buat issue di GitHub repository.

### Kontribusi
Pull requests are welcome! Untuk perubahan besar, silakan buka issue terlebih dahulu.

---

## 📝 Changelog

### Version 1.0.0 (2024)
- Initial release
- Auto installer untuk Ubuntu 24.04 LTS
- Optimizer dengan deteksi resource otomatis
- Monitoring script
- Comprehensive documentation

---

## ⚖️ License

MIT License - Bebas digunakan untuk keperluan pribadi maupun komersial.

---

## 🙏 Credits

- Pterodactyl Panel: https://pterodactyl.io
- Dibuat dengan ❤️ untuk komunitas Pterodactyl Indonesia

---

## 📚 Referensi Tambahan

- [Pterodactyl Documentation](https://pterodactyl.io/panel/1.0/getting_started.html)
- [Nginx Optimization Guide](https://www.nginx.com/blog/tuning-nginx/)
- [PHP-FPM Tuning](https://www.php.net/manual/en/install.fpm.configuration.php)
- [MariaDB Performance](https://mariadb.com/kb/en/optimization-and-tuning/)

---

**Selamat menggunakan! Jika ada pertanyaan, jangan ragu untuk bertanya.** 🚀



