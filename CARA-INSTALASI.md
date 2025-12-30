# 🚀 CARA INSTALASI PTERODACTYL PANEL
## Panduan Lengkap Step-by-Step

---

## 📋 PERSIAPAN

### 1. Persyaratan Sistem
- **OS**: Ubuntu 24.04 LTS (Fresh Install Recommended)
- **RAM**: Minimal 2GB (Recommended 4GB+)
- **Storage**: Minimal 20GB
- **Domain**: Sudah pointing ke IP server
- **Akses**: Root atau sudo access

### 2. Persiapan Server

**Login ke server via SSH:**
```bash
ssh root@your-server-ip
# atau
ssh username@your-server-ip
```

**Update sistem terlebih dahulu:**
```bash
sudo apt update && sudo apt upgrade -y
```

---

## 🎯 METODE INSTALASI

Ada 2 metode instalasi yang bisa Anda pilih:

### **METODE 1: Instalasi Otomatis (RECOMMENDED)** ⭐
Menggunakan script installer yang sudah dibuat.

### **METODE 2: Instalasi Manual**
Mengikuti langkah-langkah manual satu per satu.

---

## 📥 METODE 1: INSTALASI OTOMATIS (RECOMMENDED)

### Langkah 1: Download Script

**Opsi A - Jika file sudah ada di komputer lokal:**
```bash
# Upload file ke server menggunakan SCP
scp pterodactyl-installer.sh root@your-server-ip:/root/
scp pterodactyl-optimizer.sh root@your-server-ip:/root/
scp quick-start.sh root@your-server-ip:/root/
```

**Opsi B - Download langsung di server:**
```bash
cd /root
# Jika Anda sudah upload ke GitHub/hosting
wget https://your-url.com/pterodactyl-installer.sh
wget https://your-url.com/pterodactyl-optimizer.sh
wget https://your-url.com/quick-start.sh

# Atau copy paste manual
nano pterodactyl-installer.sh
# Paste isi file, tekan Ctrl+X, Y, Enter
```

### Langkah 2: Berikan Permission Execute
```bash
chmod +x pterodactyl-installer.sh
chmod +x pterodactyl-optimizer.sh
chmod +x quick-start.sh
```

### Langkah 3: Jalankan Installer

**Cara 1 - Menggunakan Menu Interaktif (PALING MUDAH):**
```bash
sudo bash quick-start.sh
```
Kemudian pilih opsi **[1] Install Pterodactyl Panel**

**Cara 2 - Langsung Jalankan Installer:**
```bash
sudo bash pterodactyl-installer.sh
```

### Langkah 4: Ikuti Prompt Instalasi

Script akan meminta informasi berikut:

```
1. Domain: panel.example.com
   (Ganti dengan domain Anda yang sudah pointing ke server)

2. Email: admin@example.com
   (Untuk Let's Encrypt SSL certificate)

3. MySQL Root Password: ********
   (Buat password yang kuat untuk MySQL root)

4. Pterodactyl Database Password: ********
   (Buat password yang kuat untuk database Pterodactyl)

5. Timezone: Asia/Jakarta
   (Sesuaikan dengan timezone Anda)
```

### Langkah 5: Tunggu Proses Instalasi

Proses instalasi akan memakan waktu **10-15 menit** tergantung kecepatan internet server.

Script akan otomatis:
- ✅ Install semua dependencies
- ✅ Setup database
- ✅ Install Pterodactyl Panel
- ✅ Konfigurasi Nginx
- ✅ Setup SSL certificate
- ✅ Konfigurasi firewall
- ✅ Setup queue worker

### Langkah 6: Selesai!

Setelah instalasi selesai, Anda akan melihat:
```
========================================
Installation Summary:
========================================
Panel URL: https://panel.example.com
Admin Email: admin@panel.example.com
Database: panel
Database User: pterodactyl

Next steps:
1. Access your panel at https://panel.example.com
2. Complete the admin user setup
3. Configure your mail settings in .env
4. Run optimization script: sudo bash pterodactyl-optimizer.sh
========================================
```

### Langkah 7: Setup Admin User

Akses panel Anda di browser:
```
https://panel.example.com
```

Ikuti wizard setup untuk membuat admin user pertama.

### Langkah 8: Optimasi Panel (OPTIONAL tapi RECOMMENDED)

Setelah instalasi selesai, jalankan optimizer:
```bash
sudo bash pterodactyl-optimizer.sh
```

Atau melalui menu:
```bash
sudo bash quick-start.sh
# Pilih opsi [2] Optimize Existing Panel
```

---

## 🔧 METODE 2: INSTALASI MANUAL

Jika Anda ingin instalasi manual tanpa script:

### 1. Install Dependencies

```bash
# Update sistem
sudo apt update && sudo apt upgrade -y

# Install dependencies dasar
sudo apt install -y software-properties-common curl apt-transport-https ca-certificates gnupg

# Add PHP repository
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update

# Install PHP 8.2
sudo apt install -y php8.2 php8.2-{common,cli,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip,intl,sqlite3,redis}

# Install Composer
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# Install MariaDB
sudo apt install -y mariadb-server mariadb-client

# Install Redis
sudo apt install -y redis-server

# Install Nginx
sudo apt install -y nginx

# Install Certbot
sudo apt install -y certbot python3-certbot-nginx
```

### 2. Setup Database

```bash
# Secure MariaDB
sudo mysql_secure_installation

# Login ke MySQL
sudo mysql -u root -p

# Buat database dan user
CREATE DATABASE panel;
CREATE USER 'pterodactyl'@'127.0.0.1' IDENTIFIED BY 'your_password_here';
GRANT ALL PRIVILEGES ON panel.* TO 'pterodactyl'@'127.0.0.1' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EXIT;
```

### 3. Download Pterodactyl

```bash
# Buat direktori
sudo mkdir -p /var/www/pterodactyl
cd /var/www/pterodactyl

# Download panel
sudo curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
sudo tar -xzvf panel.tar.gz
sudo chmod -R 755 storage/* bootstrap/cache/
```

### 4. Install Dependencies Pterodactyl

```bash
# Install composer dependencies
sudo COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader

# Setup environment
sudo cp .env.example .env
sudo php artisan key:generate --force
```

### 5. Konfigurasi Environment

```bash
sudo nano /var/www/pterodactyl/.env
```

Edit sesuai kebutuhan:
```env
APP_URL=https://panel.example.com
DB_HOST=127.0.0.1
DB_DATABASE=panel
DB_USERNAME=pterodactyl
DB_PASSWORD=your_password_here
CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis
```

### 6. Setup Database Schema

```bash
cd /var/www/pterodactyl
sudo php artisan migrate --seed --force
```

### 7. Buat Admin User

```bash
sudo php artisan p:user:make
```

### 8. Set Permissions

```bash
sudo chown -R www-data:www-data /var/www/pterodactyl/*
```

### 9. Konfigurasi Nginx

```bash
sudo nano /etc/nginx/sites-available/pterodactyl.conf
```

Paste konfigurasi dari file `pterodactyl-installer.sh` (bagian Nginx config).

```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/pterodactyl.conf /etc/nginx/sites-enabled/pterodactyl.conf
sudo rm /etc/nginx/sites-enabled/default

# Test dan restart
sudo nginx -t
sudo systemctl restart nginx
```

### 10. Setup SSL

```bash
sudo certbot --nginx -d panel.example.com
```

### 11. Setup Queue Worker

```bash
sudo nano /etc/systemd/system/pteroq.service
```

Paste konfigurasi dari file `pterodactyl-installer.sh` (bagian pteroq.service).

```bash
sudo systemctl enable pteroq.service
sudo systemctl start pteroq.service
```

### 12. Setup Cron

```bash
sudo crontab -e
```

Tambahkan:
```
* * * * * php /var/www/pterodactyl/artisan schedule:run >> /dev/null 2>&1
```

### 13. Konfigurasi Firewall

```bash
sudo apt install -y ufw
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8080/tcp
sudo ufw allow 2022/tcp
sudo ufw --force enable
```

---

## ✅ VERIFIKASI INSTALASI

### 1. Cek Services
```bash
sudo systemctl status nginx
sudo systemctl status php8.2-fpm
sudo systemctl status mariadb
sudo systemctl status redis-server
sudo systemctl status pteroq
```

Semua harus menunjukkan status **active (running)**.

### 2. Cek Panel
Buka browser dan akses:
```
https://panel.example.com
```

Anda harus melihat halaman login Pterodactyl.

### 3. Cek SSL Certificate
```bash
sudo certbot certificates
```

Harus menunjukkan certificate valid untuk domain Anda.

---

## 🔍 TROUBLESHOOTING

### Panel tidak bisa diakses

**1. Cek Nginx:**
```bash
sudo nginx -t
sudo systemctl status nginx
sudo systemctl restart nginx
```

**2. Cek DNS:**
```bash
ping panel.example.com
```

**3. Cek Firewall:**
```bash
sudo ufw status
```

### Error 500 / White Screen

**1. Cek PHP-FPM:**
```bash
sudo systemctl status php8.2-fpm
sudo systemctl restart php8.2-fpm
```

**2. Cek Permissions:**
```bash
cd /var/www/pterodactyl
sudo chown -R www-data:www-data *
sudo chmod -R 755 storage bootstrap/cache
```

**3. Cek Logs:**
```bash
sudo tail -f /var/log/nginx/pterodactyl.app-error.log
```

### Database Connection Error

**1. Test Connection:**
```bash
mysql -u pterodactyl -p panel
```

**2. Cek .env file:**
```bash
sudo nano /var/www/pterodactyl/.env
```

Pastikan DB_PASSWORD benar.

### Queue Worker Tidak Jalan

```bash
sudo systemctl status pteroq
sudo systemctl restart pteroq
sudo journalctl -u pteroq -n 50
```

---

## 🎯 LANGKAH SELANJUTNYA

Setelah instalasi berhasil:

### 1. Konfigurasi Email (PENTING)
```bash
sudo nano /var/www/pterodactyl/.env
```

Edit bagian MAIL:
```env
MAIL_DRIVER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=your-email@gmail.com
MAIL_FROM_NAME=Pterodactyl
```

Restart queue worker:
```bash
sudo systemctl restart pteroq
```

### 2. Install Wings (Daemon)
Wings diperlukan untuk menjalankan game servers. Ikuti dokumentasi resmi:
https://pterodactyl.io/wings/1.0/installing.html

### 3. Setup Backup Otomatis
```bash
sudo bash quick-start.sh
# Pilih opsi [5] Backup Panel & Database
```

### 4. Monitoring
```bash
# Install monitoring script (jika belum)
sudo bash pterodactyl-optimizer.sh

# Cek status
pterodactyl-monitor.sh
```

---

## 📚 RESOURCES

- **Dokumentasi Resmi**: https://pterodactyl.io/panel/1.0/getting_started.html
- **Discord Community**: https://discord.gg/pterodactyl
- **GitHub**: https://github.com/pterodactyl/panel

---

## 💡 TIPS

1. **Gunakan domain yang valid** - Jangan gunakan IP address
2. **Setup email dengan benar** - Penting untuk notifikasi dan reset password
3. **Backup secara berkala** - Gunakan script backup yang disediakan
4. **Monitor resource usage** - Gunakan pterodactyl-monitor.sh
5. **Update secara berkala** - Gunakan menu update di quick-start.sh
6. **Gunakan password yang kuat** - Untuk database dan admin user
7. **Enable 2FA** - Untuk keamanan tambahan

---

## ❓ BUTUH BANTUAN?

Jika mengalami masalah:

1. **Cek logs:**
   ```bash
   sudo tail -f /var/log/nginx/pterodactyl.app-error.log
   ```

2. **Gunakan troubleshooting menu:**
   ```bash
   sudo bash quick-start.sh
   # Pilih opsi [6] Troubleshooting & Repair
   ```

3. **Baca dokumentasi lengkap:**
   ```bash
   cat README.md
   ```

---

**Selamat! Panel Pterodactyl Anda sudah siap digunakan! 🎉**
