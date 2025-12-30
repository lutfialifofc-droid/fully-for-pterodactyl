#!/bin/bash

#############################################
# Pterodactyl Quick Start Menu
# Simplified interface for installation
#############################################

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

clear

echo -e "${CYAN}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   ██████╗ ████████╗███████╗██████╗  ██████╗              ║
║   ██╔══██╗╚══██╔══╝██╔════╝██╔══██╗██╔═══██╗             ║
║   ██████╔╝   ██║   █████╗  ██████╔╝██║   ██║             ║
║   ██╔═══╝    ██║   ██╔══╝  ██╔══██╗██║   ██║             ║
║   ██║        ██║   ███████╗██║  ██║╚██████╔╝             ║
║   ╚═╝        ╚═╝   ╚══════╝╚═╝  ╚═╝ ╚═════╝              ║
║                                                           ║
║        Pterodactyl Panel - Auto Installer & Optimizer    ║
║                  Ubuntu 24.04 LTS + Nginx                ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[ERROR]${NC} Script ini harus dijalankan sebagai root (gunakan sudo)"
   exit 1
fi

# Main menu
show_menu() {
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}Pilih opsi yang Anda inginkan:${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${CYAN}[1]${NC} 🚀 Install Pterodactyl Panel (Fresh Installation)"
    echo -e "${CYAN}[2]${NC} ⚡ Optimize Existing Panel (Untuk panel yang sudah terinstall)"
    echo -e "${CYAN}[3]${NC} 📊 Check Panel Status & Monitoring"
    echo -e "${CYAN}[4]${NC} 🔄 Update Pterodactyl Panel"
    echo -e "${CYAN}[5]${NC} 💾 Backup Panel & Database"
    echo -e "${CYAN}[6]${NC} 🔧 Troubleshooting & Repair"
    echo -e "${CYAN}[7]${NC} 📖 View Documentation"
    echo -e "${CYAN}[8]${NC} ❌ Exit"
    echo ""
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -n -e "${GREEN}Masukkan pilihan [1-8]: ${NC}"
}

# Function: Install Panel
install_panel() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         INSTALASI PTERODACTYL PANEL                       ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ -d "/var/www/pterodactyl" ]; then
        echo -e "${YELLOW}[WARNING]${NC} Pterodactyl sudah terinstall di /var/www/pterodactyl"
        echo -n "Apakah Anda ingin melanjutkan? (y/n): "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            return
        fi
    fi
    
    echo -e "${GREEN}Memulai instalasi...${NC}"
    echo ""
    
    if [ -f "pterodactyl-installer.sh" ]; then
        bash pterodactyl-installer.sh
    else
        echo -e "${RED}[ERROR]${NC} File pterodactyl-installer.sh tidak ditemukan!"
        echo "Download terlebih dahulu atau pastikan file ada di direktori yang sama."
    fi
    
    echo ""
    echo -e "${GREEN}Tekan Enter untuk kembali ke menu...${NC}"
    read
}

# Function: Optimize Panel
optimize_panel() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         OPTIMASI PTERODACTYL PANEL                        ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ ! -d "/var/www/pterodactyl" ]; then
        echo -e "${RED}[ERROR]${NC} Pterodactyl tidak ditemukan di /var/www/pterodactyl"
        echo "Silakan install terlebih dahulu menggunakan opsi [1]"
        echo ""
        echo -e "${GREEN}Tekan Enter untuk kembali ke menu...${NC}"
        read
        return
    fi
    
    echo -e "${GREEN}Memulai optimasi...${NC}"
    echo ""
    
    if [ -f "pterodactyl-optimizer.sh" ]; then
        bash pterodactyl-optimizer.sh
    else
        echo -e "${RED}[ERROR]${NC} File pterodactyl-optimizer.sh tidak ditemukan!"
        echo "Download terlebih dahulu atau pastikan file ada di direktori yang sama."
    fi
    
    echo ""
    echo -e "${GREEN}Tekan Enter untuk kembali ke menu...${NC}"
    read
}

# Function: Check Status
check_status() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         STATUS & MONITORING PANEL                         ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ -f "/usr/local/bin/pterodactyl-monitor.sh" ]; then
        bash /usr/local/bin/pterodactyl-monitor.sh
    else
        echo -e "${YELLOW}[INFO]${NC} Monitoring script belum terinstall."
        echo "Jalankan optimizer terlebih dahulu untuk menginstall monitoring script."
        echo ""
        echo "Manual check:"
        echo ""
        
        echo -e "${CYAN}Services Status:${NC}"
        systemctl is-active --quiet nginx && echo -e "${GREEN}✓${NC} Nginx: Running" || echo -e "${RED}✗${NC} Nginx: Stopped"
        systemctl is-active --quiet php8.2-fpm && echo -e "${GREEN}✓${NC} PHP-FPM: Running" || echo -e "${RED}✗${NC} PHP-FPM: Stopped"
        systemctl is-active --quiet mariadb && echo -e "${GREEN}✓${NC} MariaDB: Running" || echo -e "${RED}✗${NC} MariaDB: Stopped"
        systemctl is-active --quiet redis-server && echo -e "${GREEN}✓${NC} Redis: Running" || echo -e "${RED}✗${NC} Redis: Stopped"
        systemctl is-active --quiet pteroq && echo -e "${GREEN}✓${NC} Queue Worker: Running" || echo -e "${RED}✗${NC} Queue Worker: Stopped"
        
        echo ""
        echo -e "${CYAN}Resource Usage:${NC}"
        echo "CPU: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')"
        echo "RAM: $(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')"
        echo "Disk: $(df -h / | awk 'NR==2{print $5}')"
    fi
    
    echo ""
    echo -e "${GREEN}Tekan Enter untuk kembali ke menu...${NC}"
    read
}

# Function: Update Panel
update_panel() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         UPDATE PTERODACTYL PANEL                          ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ ! -d "/var/www/pterodactyl" ]; then
        echo -e "${RED}[ERROR]${NC} Pterodactyl tidak ditemukan!"
        echo ""
        echo -e "${GREEN}Tekan Enter untuk kembali ke menu...${NC}"
        read
        return
    fi
    
    echo -e "${YELLOW}[WARNING]${NC} Proses update akan:"
    echo "  - Membuat backup otomatis"
    echo "  - Download versi terbaru"
    echo "  - Update dependencies"
    echo "  - Migrate database"
    echo ""
    echo -n "Lanjutkan update? (y/n): "
    read -r response
    
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        return
    fi
    
    echo ""
    echo -e "${GREEN}[1/7]${NC} Membuat backup..."
    BACKUP_DIR="/root/pterodactyl-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p $BACKUP_DIR
    cp /var/www/pterodactyl/.env $BACKUP_DIR/
    mysqldump -u root -p panel > $BACKUP_DIR/panel-backup.sql 2>/dev/null || echo "Skip database backup"
    echo -e "${GREEN}✓${NC} Backup tersimpan di: $BACKUP_DIR"
    
    echo ""
    echo -e "${GREEN}[2/7]${NC} Menonaktifkan panel..."
    cd /var/www/pterodactyl
    php artisan down
    
    echo ""
    echo -e "${GREEN}[3/7]${NC} Download update..."
    curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | tar -xzv
    chmod -R 755 storage/* bootstrap/cache
    
    echo ""
    echo -e "${GREEN}[4/7]${NC} Update dependencies..."
    COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader
    
    echo ""
    echo -e "${GREEN}[5/7]${NC} Clear cache..."
    php artisan view:clear
    php artisan config:clear
    php artisan cache:clear
    
    echo ""
    echo -e "${GREEN}[6/7]${NC} Migrate database..."
    php artisan migrate --seed --force
    
    echo ""
    echo -e "${GREEN}[7/7]${NC} Optimize & restart..."
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
    chown -R www-data:www-data /var/www/pterodactyl/*
    php artisan up
    
    echo ""
    echo -e "${GREEN}✓ Update selesai!${NC}"
    echo ""
    echo -e "${GREEN}Tekan Enter untuk kembali ke menu...${NC}"
    read
}

# Function: Backup
backup_panel() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         BACKUP PANEL & DATABASE                           ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ ! -d "/var/www/pterodactyl" ]; then
        echo -e "${RED}[ERROR]${NC} Pterodactyl tidak ditemukan!"
        echo ""
        echo -e "${GREEN}Tekan Enter untuk kembali ke menu...${NC}"
        read
        return
    fi
    
    BACKUP_DIR="/root/pterodactyl-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p $BACKUP_DIR
    
    echo -e "${GREEN}Membuat backup...${NC}"
    echo ""
    
    echo -e "${CYAN}[1/4]${NC} Backup files..."
    tar -czf $BACKUP_DIR/pterodactyl-files.tar.gz /var/www/pterodactyl 2>/dev/null
    echo -e "${GREEN}✓${NC} Files backed up"
    
    echo ""
    echo -e "${CYAN}[2/4]${NC} Backup database..."
    read -sp "Masukkan MySQL root password: " MYSQL_PASS
    echo ""
    mysqldump -u root -p"$MYSQL_PASS" panel > $BACKUP_DIR/pterodactyl-db.sql 2>/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} Database backed up"
    else
        echo -e "${YELLOW}⚠${NC} Database backup skipped (password salah atau database tidak ada)"
    fi
    
    echo ""
    echo -e "${CYAN}[3/4]${NC} Backup configurations..."
    cp /var/www/pterodactyl/.env $BACKUP_DIR/ 2>/dev/null
    cp /etc/nginx/sites-available/pterodactyl.conf $BACKUP_DIR/ 2>/dev/null
    cp /etc/php/8.2/fpm/pool.d/www.conf $BACKUP_DIR/ 2>/dev/null
    echo -e "${GREEN}✓${NC} Configurations backed up"
    
    echo ""
    echo -e "${CYAN}[4/4]${NC} Creating backup info..."
    cat > $BACKUP_DIR/backup-info.txt <<EOF
Pterodactyl Backup Information
==============================
Backup Date: $(date)
Backup Location: $BACKUP_DIR

Contents:
- pterodactyl-files.tar.gz (Panel files)
- pterodactyl-db.sql (Database dump)
- .env (Environment configuration)
- pterodactyl.conf (Nginx configuration)
- www.conf (PHP-FPM configuration)

Restore Instructions:
1. Stop services: systemctl stop nginx php8.2-fpm pteroq
2. Restore files: tar -xzf pterodactyl-files.tar.gz -C /
3. Restore database: mysql -u root -p panel < pterodactyl-db.sql
4. Set permissions: chown -R www-data:www-data /var/www/pterodactyl
5. Start services: systemctl start nginx php8.2-fpm pteroq
EOF
    
    echo -e "${GREEN}✓${NC} Backup info created"
    
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✓ Backup berhasil dibuat!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Lokasi backup: $BACKUP_DIR"
    echo ""
    echo "Isi backup:"
    ls -lh $BACKUP_DIR
    
    echo ""
    echo -e "${GREEN}Tekan Enter untuk kembali ke menu...${NC}"
    read
}

# Function: Troubleshooting
troubleshooting() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         TROUBLESHOOTING & REPAIR                          ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${YELLOW}Pilih masalah yang ingin diperbaiki:${NC}"
    echo ""
    echo -e "${CYAN}[1]${NC} Fix Permissions (chmod/chown)"
    echo -e "${CYAN}[2]${NC} Restart All Services"
    echo -e "${CYAN}[3]${NC} Clear All Caches"
    echo -e "${CYAN}[4]${NC} Fix Queue Worker"
    echo -e "${CYAN}[5]${NC} Test Database Connection"
    echo -e "${CYAN}[6]${NC} View Recent Errors"
    echo -e "${CYAN}[7]${NC} Kembali ke Menu Utama"
    echo ""
    echo -n -e "${GREEN}Pilih [1-7]: ${NC}"
    read -r choice
    
    case $choice in
        1)
            echo ""
            echo -e "${GREEN}Memperbaiki permissions...${NC}"
            cd /var/www/pterodactyl
            chown -R www-data:www-data *
            chmod -R 755 storage bootstrap/cache
            echo -e "${GREEN}✓${NC} Permissions diperbaiki"
            ;;
        2)
            echo ""
            echo -e "${GREEN}Restart semua services...${NC}"
            systemctl restart php8.2-fpm
            systemctl restart nginx
            systemctl restart mariadb
            systemctl restart redis-server
            systemctl restart pteroq
            echo -e "${GREEN}✓${NC} Semua services direstart"
            ;;
        3)
            echo ""
            echo -e "${GREEN}Clearing caches...${NC}"
            cd /var/www/pterodactyl
            php artisan cache:clear
            php artisan config:clear
            php artisan route:clear
            php artisan view:clear
            echo -e "${GREEN}✓${NC} Cache dibersihkan"
            ;;
        4)
            echo ""
            echo -e "${GREEN}Memperbaiki queue worker...${NC}"
            systemctl stop pteroq
            systemctl daemon-reload
            systemctl enable pteroq
            systemctl start pteroq
            systemctl status pteroq
            ;;
        5)
            echo ""
            echo -e "${GREEN}Testing database connection...${NC}"
            mysql -e "SELECT VERSION();" && echo -e "${GREEN}✓${NC} Database OK" || echo -e "${RED}✗${NC} Database Error"
            ;;
        6)
            echo ""
            echo -e "${GREEN}Recent errors (last 20 lines):${NC}"
            echo ""
            tail -n 20 /var/log/nginx/pterodactyl.app-error.log 2>/dev/null || echo "No error log found"
            ;;
        7)
            return
            ;;
        *)
            echo -e "${RED}Pilihan tidak valid${NC}"
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}Tekan Enter untuk kembali...${NC}"
    read
    troubleshooting
}

# Function: View Documentation
view_docs() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         DOKUMENTASI                                       ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ -f "README.md" ]; then
        less README.md
    else
        echo -e "${YELLOW}README.md tidak ditemukan.${NC}"
        echo ""
        echo "Dokumentasi online:"
        echo "- Pterodactyl: https://pterodactyl.io/panel/1.0/getting_started.html"
        echo "- GitHub: https://github.com/pterodactyl/panel"
    fi
    
    echo ""
    echo -e "${GREEN}Tekan Enter untuk kembali ke menu...${NC}"
    read
}

# Main loop
while true; do
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║   Pterodactyl Panel - Auto Installer & Optimizer         ║
║   Ubuntu 24.04 LTS + Nginx                               ║
╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    show_menu
    read -r choice
    
    case $choice in
        1) install_panel ;;
        2) optimize_panel ;;
        3) check_status ;;
        4) update_panel ;;
        5) backup_panel ;;
        6) troubleshooting ;;
        7) view_docs ;;
        8) 
            clear
            echo -e "${GREEN}Terima kasih telah menggunakan Pterodactyl Auto Installer!${NC}"
            echo ""
            exit 0
            ;;
        *)
            echo -e "${RED}Pilihan tidak valid. Silakan pilih 1-8.${NC}"
            sleep 2
            ;;
    esac
done
