# 🦅 PTERODACTYL WINGS INSTALLATION GUIDE
## Ubuntu 24.04 LTS - Daemon/Node Setup

Wings adalah daemon yang menjalankan game servers di Pterodactyl Panel. Panduan ini akan membantu Anda menginstall dan mengkonfigurasi Wings.

---

## 📋 PERSYARATAN

### Sistem Requirements
- **OS**: Ubuntu 24.04 LTS
- **RAM**: Minimal 2GB (4GB+ recommended untuk game servers)
- **CPU**: Minimal 2 cores (4+ cores recommended)
- **Storage**: Minimal 20GB (tergantung jumlah game servers)
- **Network**: Port 8080, 2022, dan port game servers harus terbuka
- **Panel**: Pterodactyl Panel sudah terinstall dan berjalan

### Yang Dibutuhkan
- Akses root/sudo ke server
- Domain/subdomain untuk Wings (optional tapi recommended)
- Panel URL yang sudah berjalan
- Node sudah dibuat di Panel

---

## 🚀 INSTALASI OTOMATIS

### Metode 1: Menggunakan Quick Start Menu V2 (RECOMMENDED)

```bash
# Upload script ke server
scp quick-start-v2.sh root@your-node-server:/root/
scp wings-installer.sh root@your-node-server:/root/

# Login ke server
ssh root@your-node-server

# Berikan permission
chmod +x *.sh

# Jalankan menu
sudo bash quick-start-v2.sh

# Pilih opsi [4] Install Wings
```

### Metode 2: Langsung Jalankan Wings Installer

```bash
chmod +x wings-installer.sh
sudo bash wings-installer.sh
```

**Installer akan meminta:**
1. Panel URL (contoh: https://panel.example.com)
2. FQDN untuk node (contoh: node1.example.com)

**Installer akan otomatis:**
- ✅ Install Docker & Docker Compose
- ✅ Download Wings versi terbaru
- ✅ Setup systemd service
- ✅ Konfigurasi firewall
- ✅ Setup SSL certificate (optional)
- ✅ Optimasi kernel parameters
- ✅ Setup swap memory
- ✅ Create management script

---

## 📝 KONFIGURASI WINGS

### Langkah 1: Buat Node di Panel

1. Login ke Panel sebagai admin
2. Pergi ke **Admin Panel** → **Nodes**
3. Klik **Create New**
4. Isi informasi node:
   - **Name**: Nama node (contoh: Node 1)
   - **Description**: Deskripsi node
   - **Location**: Pilih lokasi
   - **FQDN**: Domain node (contoh: node1.example.com)
   - **Communicate Over SSL**: Yes (jika menggunakan SSL)
   - **Behind Proxy**: No (kecuali menggunakan proxy)
   - **Daemon Port**: 8080
   - **Memory**: Total RAM yang dialokasikan
   - **Disk**: Total disk yang dialokasikan
   - **Upload Size**: 100 (MB)

5. Klik **Create Node**

### Langkah 2: Dapatkan Konfigurasi

1. Setelah node dibuat, klik node tersebut
2. Pergi ke tab **Configuration**
3. Copy seluruh konfigurasi yang ditampilkan

### Langkah 3: Paste Konfigurasi ke Server

```bash
# Edit config file
nano /etc/pterodactyl/config.yml

# Paste konfigurasi dari Panel
# Save: Ctrl+X, Y, Enter
```

**Contoh konfigurasi:**
```yaml
debug: false
uuid: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
token_id: xxxxxxxxxxxxxxxx
token: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
api:
  host: 0.0.0.0
  port: 8080
  ssl:
    enabled: true
    cert: /etc/letsencrypt/live/node1.example.com/fullchain.pem
    key: /etc/letsencrypt/live/node1.example.com/privkey.pem
  upload_limit: 100
system:
  data: /var/lib/pterodactyl/volumes
  sftp:
    bind_port: 2022
allowed_mounts: []
remote: https://panel.example.com
```

### Langkah 4: Start Wings

```bash
# Start Wings service
systemctl start wings

# Check status
systemctl status wings

# Enable auto-start on boot
systemctl enable wings
```

---

## 🔧 MANAGEMENT WINGS

### Menggunakan Wings Manager Script

```bash
# Start Wings
wings-manager.sh start

# Stop Wings
wings-manager.sh stop

# Restart Wings
wings-manager.sh restart

# Check status
wings-manager.sh status

# View logs
wings-manager.sh logs

# Update Wings
wings-manager.sh update

# Edit configuration
wings-manager.sh configure
```

### Manual Commands

```bash
# Start
systemctl start wings

# Stop
systemctl stop wings

# Restart
systemctl restart wings

# Status
systemctl status wings

# Logs (real-time)
journalctl -u wings -f

# Logs (last 100 lines)
journalctl -u wings -n 100
```

---

## 🔍 VERIFIKASI INSTALASI

### 1. Check Wings Service

```bash
systemctl status wings
```

Harus menunjukkan: **active (running)**

### 2. Check Docker

```bash
docker --version
docker ps
```

### 3. Check Firewall

```bash
ufw status
```

Ports yang harus terbuka:
- 8080/tcp (Wings API)
- 2022/tcp (SFTP)
- 25565-25665/tcp & udp (Game servers)

### 4. Check di Panel

1. Login ke Panel
2. Pergi ke **Admin Panel** → **Nodes**
3. Node harus menunjukkan status **Online** dengan heartbeat hijau

### 5. Test Connection

```bash
# Test Wings API
curl -k https://node1.example.com:8080

# Should return: {"error":"The required authorization heads were not present in the request."}
# This is normal - it means Wings is running
```

---

## 🎮 MEMBUAT SERVER PERTAMA

### Di Panel:

1. **Admin Panel** → **Servers** → **Create New**
2. Isi informasi server:
   - **Server Name**: Nama server
   - **Server Owner**: Pilih user
   - **Node**: Pilih node yang sudah dibuat
   - **Allocation**: Pilih IP:Port
   - **Memory**: Alokasi RAM
   - **Disk**: Alokasi disk
   - **CPU**: Alokasi CPU
   - **Nest**: Pilih game (Minecraft, etc)
   - **Egg**: Pilih versi game

3. Klik **Create Server**

### Verifikasi:

```bash
# Check running containers
docker ps

# Check Wings logs
journalctl -u wings -f
```

---

## 🔧 TROUBLESHOOTING

### Wings Tidak Start

**Check logs:**
```bash
journalctl -u wings -n 50
```

**Common issues:**
1. **Config file tidak ada**
   ```bash
   ls -la /etc/pterodactyl/config.yml
   ```
   Solusi: Paste konfigurasi dari Panel

2. **Docker tidak running**
   ```bash
   systemctl status docker
   systemctl start docker
   ```

3. **Port sudah digunakan**
   ```bash
   netstat -tlnp | grep 8080
   ```
   Solusi: Stop service yang menggunakan port 8080

### Wings Offline di Panel

**Check:**
1. Wings service running?
   ```bash
   systemctl status wings
   ```

2. Firewall blocking?
   ```bash
   ufw status
   ufw allow 8080/tcp
   ```

3. SSL certificate valid?
   ```bash
   certbot certificates
   ```

4. Config correct?
   ```bash
   cat /etc/pterodactyl/config.yml
   ```

### Server Tidak Start

**Check:**
1. Wings logs
   ```bash
   journalctl -u wings -f
   ```

2. Docker logs
   ```bash
   docker ps -a
   docker logs <container_id>
   ```

3. Disk space
   ```bash
   df -h
   ```

4. Memory available
   ```bash
   free -h
   ```

### SFTP Tidak Berfungsi

**Check:**
1. Port 2022 terbuka
   ```bash
   ufw allow 2022/tcp
   ```

2. Wings running
   ```bash
   systemctl status wings
   ```

3. Test SFTP connection
   ```bash
   sftp -P 2022 <username>.<server_id>@node1.example.com
   ```

---

## ⚡ OPTIMASI WINGS

### 1. Kernel Parameters (Sudah dilakukan oleh installer)

```bash
# Check current settings
sysctl -a | grep -E "net.core|net.ipv4|vm.swappiness"
```

### 2. Docker Optimization

```bash
# Edit Docker daemon config
nano /etc/docker/daemon.json
```

Add:
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
```

Restart Docker:
```bash
systemctl restart docker
```

### 3. Increase File Limits

Already configured by installer, but you can verify:
```bash
cat /etc/security/limits.conf | grep nofile
```

### 4. Monitor Resource Usage

```bash
# CPU & Memory
htop

# Docker stats
docker stats

# Disk usage
df -h
du -sh /var/lib/pterodactyl/volumes/*
```

---

## 🔄 UPDATE WINGS

### Menggunakan Wings Manager

```bash
wings-manager.sh update
```

### Manual Update

```bash
# Stop Wings
systemctl stop wings

# Download latest version
curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64"

# Set permissions
chmod +x /usr/local/bin/wings

# Start Wings
systemctl start wings

# Verify version
wings --version
```

---

## 💾 BACKUP WINGS

### Backup Configuration

```bash
# Create backup directory
mkdir -p /root/wings-backup-$(date +%Y%m%d)

# Backup config
cp /etc/pterodactyl/config.yml /root/wings-backup-$(date +%Y%m%d)/

# Backup server data (optional, bisa sangat besar)
tar -czf /root/wings-backup-$(date +%Y%m%d)/server-data.tar.gz /var/lib/pterodactyl/volumes/
```

### Restore Configuration

```bash
# Stop Wings
systemctl stop wings

# Restore config
cp /root/wings-backup-YYYYMMDD/config.yml /etc/pterodactyl/

# Start Wings
systemctl start wings
```

---

## 🔒 KEAMANAN

### 1. SSL Certificate (Recommended)

```bash
# Install certbot
apt install -y certbot

# Generate certificate
certbot certonly --standalone -d node1.example.com

# Update Wings config
nano /etc/pterodactyl/config.yml
```

Set:
```yaml
api:
  ssl:
    enabled: true
    cert: /etc/letsencrypt/live/node1.example.com/fullchain.pem
    key: /etc/letsencrypt/live/node1.example.com/privkey.pem
```

### 2. Firewall Rules

```bash
# Only allow necessary ports
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 8080/tcp
ufw allow 2022/tcp
ufw allow 25565:25665/tcp
ufw allow 25565:25665/udp
ufw enable
```

### 3. Fail2ban (Optional)

```bash
apt install -y fail2ban
systemctl enable fail2ban
systemctl start fail2ban
```

---

## 📊 MONITORING

### Check Wings Health

```bash
# Service status
systemctl status wings

# Resource usage
docker stats

# Disk usage
df -h /var/lib/pterodactyl/volumes

# Network connections
netstat -tlnp | grep wings
```

### Setup Monitoring Script

```bash
cat > /usr/local/bin/wings-health-check.sh <<'EOF'
#!/bin/bash
echo "=== Wings Health Check ==="
echo ""
echo "Wings Service:"
systemctl is-active --quiet wings && echo "✓ Running" || echo "✗ Stopped"
echo ""
echo "Docker Service:"
systemctl is-active --quiet docker && echo "✓ Running" || echo "✗ Stopped"
echo ""
echo "Running Containers:"
docker ps --format "table {{.Names}}\t{{.Status}}"
echo ""
echo "Resource Usage:"
echo "CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')%"
echo "RAM: $(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')"
echo "Disk: $(df -h /var/lib/pterodactyl/volumes | awk 'NR==2{print $5}')"
EOF

chmod +x /usr/local/bin/wings-health-check.sh

# Run health check
wings-health-check.sh
```

---

## 📚 REFERENSI

- **Wings Documentation**: https://pterodactyl.io/wings/1.0/installing.html
- **Docker Documentation**: https://docs.docker.com/
- **Pterodactyl Discord**: https://discord.gg/pterodactyl
- **GitHub Issues**: https://github.com/pterodactyl/wings/issues

---

## ❓ FAQ

### Q: Apakah Wings harus di server terpisah dari Panel?
**A:** Tidak wajib, tapi sangat direkomendasikan untuk production. Panel dan Wings bisa di server yang sama untuk testing.

### Q: Berapa banyak server yang bisa dijalankan di satu Wings?
**A:** Tergantung resource server. Sebagai patokan: 1GB RAM per Minecraft server, 2GB untuk modded.

### Q: Apakah bisa menjalankan multiple Wings di satu server?
**A:** Tidak recommended. Lebih baik gunakan satu Wings per server.

### Q: Bagaimana cara menambah port untuk game servers?
**A:** Di Panel, pergi ke Node → Allocation → Create Allocation

### Q: Wings menggunakan banyak disk space, normal?
**A:** Ya, Wings menyimpan semua server files. Monitor dengan `du -sh /var/lib/pterodactyl/volumes/*`

---

**Wings berhasil terinstall! Selamat menjalankan game servers! 🎮**

**Butuh bantuan? Baca [TROUBLESHOOTING.md](TROUBLESHOOTING.md) atau join Discord Pterodactyl**
