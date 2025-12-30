# 🔧 TROUBLESHOOTING GUIDE
## Solusi untuk Masalah Umum Instalasi Pterodactyl

---

## ❌ ERROR: Application Key

### **Masalah:**
```
ERROR: Application key not set
```
atau
```
APP_KEY is empty
```

### **Penyebab:**
- Application key tidak ter-generate dengan benar
- File .env tidak memiliki APP_KEY yang valid

### **Solusi:**

**Metode 1 - Generate Ulang Key:**
```bash
cd /var/www/pterodactyl
php artisan key:generate --force
```

**Metode 2 - Manual Generate:**
```bash
cd /var/www/pterodactyl

# Backup .env lama
cp .env .env.backup

# Generate key baru
php artisan key:generate --force

# Verify key sudah ada
grep "APP_KEY" .env
```

Harusnya muncul seperti ini:
```
APP_KEY=base64:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Metode 3 - Jika Masih Gagal:**
```bash
cd /var/www/pterodactyl

# Clear cache
php artisan config:clear
php artisan cache:clear

# Generate key lagi
php artisan key:generate --force

# Set permissions
chown -R www-data:www-data /var/www/pterodactyl
chmod -R 755 storage bootstrap/cache

# Restart services
systemctl restart php8.2-fpm
systemctl restart nginx
```

---

## ❌ ERROR 1045: Access Denied for MySQL

### **Masalah:**
```
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)
```
atau
```
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)
```

### **Penyebab:**
- Password MySQL root tidak ter-set dengan benar
- MySQL authentication plugin issue
- Password salah

### **Solusi:**

**Metode 1 - Reset Password MySQL (RECOMMENDED):**

```bash
# Stop MySQL
sudo systemctl stop mariadb

# Start MySQL in safe mode
sudo mysqld_safe --skip-grant-tables &

# Wait 5 seconds
sleep 5

# Login tanpa password
mysql -u root

# Di MySQL prompt, jalankan:
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'password_baru_anda';
FLUSH PRIVILEGES;
EXIT;

# Kill safe mode process
sudo pkill mysqld_safe
sudo pkill mysqld

# Start MySQL normal
sudo systemctl start mariadb

# Test login
mysql -u root -p
# Masukkan password baru
```

**Metode 2 - Menggunakan mysql_secure_installation:**

```bash
# Jalankan secure installation
sudo mysql_secure_installation

# Ikuti prompt:
# - Enter current password (tekan Enter jika kosong)
# - Set root password? Y
# - Masukkan password baru
# - Remove anonymous users? Y
# - Disallow root login remotely? Y
# - Remove test database? Y
# - Reload privilege tables? Y
```

**Metode 3 - Manual Fix untuk MariaDB:**

```bash
# Login ke MySQL tanpa password (jika bisa)
sudo mysql

# Di MySQL prompt:
USE mysql;
UPDATE user SET plugin='mysql_native_password' WHERE User='root';
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'password_baru_anda';
FLUSH PRIVILEGES;
EXIT;

# Restart MySQL
sudo systemctl restart mariadb

# Test
mysql -u root -p
```

**Metode 4 - Jika Semua Gagal (Complete Reset):**

```bash
# PERINGATAN: Ini akan menghapus semua database!
# Backup dulu jika ada data penting

# Stop MySQL
sudo systemctl stop mariadb

# Remove MySQL data
sudo rm -rf /var/lib/mysql/*

# Reinstall MySQL
sudo apt purge mariadb-server mariadb-client -y
sudo apt autoremove -y
sudo apt install mariadb-server mariadb-client -y

# Start MySQL
sudo systemctl start mariadb

# Set password baru
sudo mysql_secure_installation
```

---

## ❌ ERROR: Database Connection Failed

### **Masalah:**
```
SQLSTATE[HY000] [1045] Access denied for user 'pterodactyl'@'127.0.0.1'
```

### **Solusi:**

**1. Cek Database User:**
```bash
mysql -u root -p

# Di MySQL prompt:
SELECT User, Host FROM mysql.user WHERE User='pterodactyl';

# Jika tidak ada, buat user:
CREATE USER 'pterodactyl'@'127.0.0.1' IDENTIFIED BY 'password_anda';
GRANT ALL PRIVILEGES ON panel.* TO 'pterodactyl'@'127.0.0.1';
FLUSH PRIVILEGES;
EXIT;
```

**2. Cek .env File:**
```bash
nano /var/www/pterodactyl/.env

# Pastikan:
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=panel
DB_USERNAME=pterodactyl
DB_PASSWORD=password_yang_benar
```

**3. Test Connection:**
```bash
mysql -u pterodactyl -p -h 127.0.0.1 panel
# Masukkan password
```

---

## ❌ ERROR: Composer Install Failed

### **Masalah:**
```
Your requirements could not be resolved to an installable set of packages
```

### **Solusi:**

```bash
cd /var/www/pterodactyl

# Clear composer cache
COMPOSER_ALLOW_SUPERUSER=1 composer clear-cache

# Update composer
COMPOSER_ALLOW_SUPERUSER=1 composer self-update

# Install dengan flag tambahan
COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader --no-interaction

# Jika masih error, coba:
COMPOSER_ALLOW_SUPERUSER=1 composer update --no-dev --optimize-autoloader
```

---

## ❌ ERROR: Permission Denied

### **Masalah:**
```
Permission denied
```
atau
```
Failed to open stream: Permission denied
```

### **Solusi:**

```bash
cd /var/www/pterodactyl

# Set ownership
sudo chown -R www-data:www-data /var/www/pterodactyl

# Set permissions
sudo chmod -R 755 /var/www/pterodactyl
sudo chmod -R 755 storage
sudo chmod -R 755 bootstrap/cache

# Jika masih error:
sudo chmod -R 775 storage
sudo chmod -R 775 bootstrap/cache

# Restart PHP-FPM
sudo systemctl restart php8.2-fpm
```

---

## ❌ ERROR: 502 Bad Gateway

### **Masalah:**
Nginx menampilkan 502 Bad Gateway

### **Solusi:**

**1. Cek PHP-FPM:**
```bash
sudo systemctl status php8.2-fpm

# Jika stopped, start:
sudo systemctl start php8.2-fpm

# Cek error log:
sudo tail -f /var/log/php8.2-fpm.log
```

**2. Cek Socket:**
```bash
# Pastikan socket ada
ls -la /run/php/php8.2-fpm.sock

# Jika tidak ada, restart PHP-FPM:
sudo systemctl restart php8.2-fpm
```

**3. Cek Nginx Config:**
```bash
sudo nginx -t

# Jika error, edit config:
sudo nano /etc/nginx/sites-available/pterodactyl.conf

# Pastikan fastcgi_pass benar:
fastcgi_pass unix:/run/php/php8.2-fpm.sock;
```

---

## ❌ ERROR: SSL Certificate Failed

### **Masalah:**
```
Certbot failed to authenticate
```

### **Solusi:**

**1. Cek DNS:**
```bash
# Pastikan domain pointing ke server
ping panel.example.com
nslookup panel.example.com
```

**2. Cek Port 80:**
```bash
# Pastikan port 80 terbuka
sudo ufw allow 80/tcp
sudo netstat -tlnp | grep :80
```

**3. Manual Certbot:**
```bash
# Stop Nginx
sudo systemctl stop nginx

# Get certificate
sudo certbot certonly --standalone -d panel.example.com

# Start Nginx
sudo systemctl start nginx

# Update Nginx config
sudo nano /etc/nginx/sites-available/pterodactyl.conf

# Update SSL paths:
ssl_certificate /etc/letsencrypt/live/panel.example.com/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/panel.example.com/privkey.pem;

# Test dan restart
sudo nginx -t
sudo systemctl restart nginx
```

---

## ❌ ERROR: Queue Worker Not Running

### **Masalah:**
```
Queue worker is not running
```

### **Solusi:**

```bash
# Cek status
sudo systemctl status pteroq

# Jika failed, cek log:
sudo journalctl -u pteroq -n 50

# Restart worker
sudo systemctl restart pteroq

# Jika masih gagal, recreate service:
sudo systemctl stop pteroq
sudo systemctl disable pteroq

# Edit service file
sudo nano /etc/systemd/system/pteroq.service

# Reload dan start
sudo systemctl daemon-reload
sudo systemctl enable pteroq
sudo systemctl start pteroq
```

---

## ❌ ERROR: Migration Failed

### **Masalah:**
```
Migration failed
```
atau
```
SQLSTATE[42S01]: Base table or view already exists
```

### **Solusi:**

**Metode 1 - Fresh Migration:**
```bash
cd /var/www/pterodactyl

# Backup database dulu!
mysqldump -u root -p panel > /root/panel-backup.sql

# Drop dan recreate database
mysql -u root -p
DROP DATABASE panel;
CREATE DATABASE panel;
EXIT;

# Run migration lagi
php artisan migrate --seed --force
```

**Metode 2 - Rollback:**
```bash
cd /var/www/pterodactyl

# Rollback migration
php artisan migrate:rollback

# Run migration lagi
php artisan migrate --seed --force
```

---

## 🔍 DIAGNOSTIC COMMANDS

### Cek Semua Services:
```bash
sudo systemctl status nginx
sudo systemctl status php8.2-fpm
sudo systemctl status mariadb
sudo systemctl status redis-server
sudo systemctl status pteroq
```

### Cek Logs:
```bash
# Nginx error log
sudo tail -f /var/log/nginx/pterodactyl.app-error.log

# PHP-FPM log
sudo tail -f /var/log/php8.2-fpm.log

# Queue worker log
sudo journalctl -u pteroq -f

# System log
sudo tail -f /var/log/syslog
```

### Cek Permissions:
```bash
ls -la /var/www/pterodactyl
ls -la /var/www/pterodactyl/storage
ls -la /var/www/pterodactyl/bootstrap/cache
```

### Cek Database:
```bash
mysql -u root -p

# Di MySQL:
SHOW DATABASES;
USE panel;
SHOW TABLES;
SELECT * FROM users;
EXIT;
```

---

## 🆘 EMERGENCY FIX

Jika semua gagal, gunakan script troubleshooting:

```bash
sudo bash quick-start.sh
# Pilih opsi [6] Troubleshooting & Repair
```

Atau manual:

```bash
# Stop semua services
sudo systemctl stop nginx php8.2-fpm mariadb redis-server pteroq

# Fix permissions
cd /var/www/pterodactyl
sudo chown -R www-data:www-data *
sudo chmod -R 755 storage bootstrap/cache

# Clear cache
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Regenerate key
php artisan key:generate --force

# Start services
sudo systemctl start mariadb
sudo systemctl start redis-server
sudo systemctl start php8.2-fpm
sudo systemctl start nginx
sudo systemctl start pteroq

# Check status
sudo systemctl status nginx php8.2-fpm mariadb redis-server pteroq
```

---

## 📞 BUTUH BANTUAN LEBIH?

1. **Cek logs untuk error spesifik**
2. **Screenshot error message**
3. **Jalankan diagnostic commands di atas**
4. **Baca dokumentasi resmi**: https://pterodactyl.io
5. **Join Discord**: https://discord.gg/pterodactyl

---

**Tip:** Selalu backup sebelum melakukan perubahan besar!
