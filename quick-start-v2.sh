#!/bin/bash

#############################################
# Pterodactyl Quick Start Menu V2
# Panel + Wings Installation
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
2
echo -e "${CYAN}"
cat << "EOF"
                          |===========================================================|
                     -                                                          -
                         -           .     █▀▀  █░█  █░░  █░░  █▄█          .          -
                        -               .  █▀░  █▄█  █▄▄  █▄▄  ░█░             .      -
                 -                                               .            -
                         -                 .    █▀▀  █▀█  █▀█                  .      -
                           -              .     █▀░  █▄█  █▀▄              .           -
                                -                                                  .       -
                          -    █▀█  ▀█▀  █▀▀  █▀█  █▀█  █▀▄  ▄▀█  █▀▀  ▀█▀  █▄█       -
                        -      █▀▀  ░█░  ██▄  █▀▄  █▄█  █▄▀  █▀█  █▄▄  ░█░  ░█░      -  
                        -                                                           -        
                             -         CREATED BY LUTFIALIFOFC-DROID                   -    
                          -     THIS SCRIPT SUPPORT FOR UBUNTU 24.04 ONLY             -
                           -               SCRIPT VERSION 1.0                        -
                          |============================================================|
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
    echo -e "${GREEN}                       OPTION:${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${PURPLE}=== PANEL ===${NC}"                                                       
    echo -e "${CYAN}[1]${NC} 🚀 Install Pterodactyl Panel"
    echo -e "${CYAN}[2]${NC} ⚡ Optimize Panel"
    echo -e "${CYAN}[3]${NC} 🔄 Update Panel"
    echo ""
                                                             echo -e "${PURPLE}=== WINGS (NODE) ===${NC}"
                                                             echo -e "${CYAN}[4]${NC} 🦅 Install Wings (Daemon/Node)"
                                                             echo -e "${CYAN}[5]${NC} 🔧 Manage Wings (Start/Stop/Restart)"
                                                             echo -e "${CYAN}[6]${NC} 📝 Configure Wings"
    echo ""
    echo -e "${PURPLE}=== MONITORING & MAINTENANCE ===${NC}"
    echo -e "${CYAN}[7]${NC} 📊 Check System Status"
    echo -e "${CYAN}[8]${NC} 💾 Backup Panel & Database"
    echo -e "${CYAN}[9]${NC} 🔧 Troubleshooting & Repair"
    echo ""
                                                             echo -e "${PURPLE}=== OTHER ===${NC}"
                                                             echo -e "${CYAN}[10]${NC} 📖 View Documentation"
                                                             echo -e "${CYAN}[11]${NC} ❌ Exit"
    echo ""
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════${NC}"
    echo -n -e "${GREEN}           Masukkan pilihan [1-11]: ${NC}"
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
    
    echo -e "${GREEN}Memulai instalasi Panel...${NC}"
    echo ""
    
    if [ -f "pterodactyl-installer.sh" ]; then
        bash pterodactyl-installer.sh
    else
        echo -e "${RED}[ERROR]${NC} File pterodactyl-installer.sh tidak ditemukan!"
    fi
    
    echo ""
    echo -e "${GREEN}Tekan Enter untuk kembali ke menu...${NC}"
    read
}

# Function: Install Wings
install_wings() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         INSTALASI PTERODACTYL WINGS                       ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if command -v wings &> /dev/null; then
        echo -e "${YELLOW}[WARNING]${NC} Wings sudah terinstall"
        echo "Version: $(wings --version)"
        echo -n "Apakah Anda ingin reinstall? (y/n): "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            return
        fi
    fi
    
    echo -e "${GREEN}Memulai instalasi Wings...${NC}"
    echo ""
    
    if [ -f "wings-installer.sh" ]; then
        bash wings-installer.sh
    else
        echo -e "${RED}[ERROR]${NC} File wings-installer.sh tidak ditemukan!"
    fi
    
    echo ""
    echo -e "${GREEN}Tekan Enter untuk kembali ke menu...${NC}"
    read
}

# Function: Manage Wings
manage_wings() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         MANAGE WINGS                                      ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if ! command -v wings &> /dev/null; then
        echo -e "${RED}[ERROR]${NC} Wings belum terinstall!"
        echo "Install Wings terlebih dahulu menggunakan opsi [4]"
        echo ""
        echo -e "${GREEN}Tekan Enter untuk kembali ke menu...${NC}"
        read
        return
    fi
    
    echo -e "${YELLOW}Pilih aksi:${NC}"
    echo ""
    echo -e "${CYAN}[1]${NC} Start Wings"
    echo -e "${CYAN}[2]${NC} Stop Wings"
    echo -e "${CYAN}[3]${NC} Restart Wings"
    echo -e "${CYAN}[4]${NC} Check Wings Status"
    echo -e "${CYAN}[5]${NC} View Wings Logs"
    echo -e "${CYAN}[6]${NC} Update Wings"
    echo -e "${CYAN}[7]${NC} Kembali ke Menu Utama"
    echo ""
    echo -n -e "${GREEN}Pilih [1-7]: ${NC}"
    read -r choice
    
    case $choice in
        1)
            echo ""
            echo -e "${GREEN}Starting Wings...${NC}"
            systemctl start wings
            systemctl status wings --no-pager
            ;;
        2)
            echo ""
            echo -e "${GREEN}Stopping Wings...${NC}"
            systemctl stop wings
            echo -e "${GREEN}✓${NC} Wings stopped"
            ;;
        3)
            echo ""
            echo -e "${GREEN}Restarting Wings...${NC}"
            systemctl restart wings
            systemctl status wings --no-pager
            ;;
        4)
            echo ""
            systemctl status wings
            ;;
        5)
            echo ""
            echo -e "${GREEN}Wings Logs (Ctrl+C to exit):${NC}"
            journalctl -u wings -f
            ;;
        6)
            echo ""
            echo -e "${GREEN}Updating Wings...${NC}"
            systemctl stop wings
            curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64"
            chmod +x /usr/local/bin/wings
            systemctl start wings
            echo -e "${GREEN}✓${NC} Wings updated to latest version"
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
    manage_wings
}

# Function: Configure Wings
configure_wings() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         CONFIGURE WINGS                                   ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    if [ ! -f "/etc/pterodactyl/config.yml" ]; then
        echo -e "${YELLOW}[WARNING]${NC} Config file tidak ditemukan!"
        echo ""
        echo "Langkah-langkah konfigurasi Wings:"
        echo "1. Login ke Panel: https://your-panel-url.com/admin"
        echo "2. Buat Node baru atau pilih node existing"
        echo "3. Pergi ke tab 'Configuration'"
        echo "4. Copy konfigurasi yang ditampilkan"
        echo "5. Paste ke file: /etc/pterodactyl/config.yml"
        echo ""
        echo -n "Apakah Anda ingin membuka editor sekarang? (y/n): "
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            nano /etc/pterodactyl/config.yml
        fi
    else
        echo "Config file ditemukan: /etc/pterodactyl/config.yml"
        echo ""
        echo -n "Apakah Anda ingin edit config? (y/n): "
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            nano /etc/pterodactyl/config.yml
            
            echo ""
            echo -n "Restart Wings untuk apply perubahan? (y/n): "
            read -r restart
            if [[ "$restart" =~ ^[Yy]$ ]]; then
                systemctl restart wings
                echo -e "${GREEN}✓${NC} Wings restarted"
            fi
        fi
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
        echo -e "${RED}[ERROR]${NC} Pterodactyl tidak ditemukan"
        echo ""
        echo -e "${GREEN}Tekan Enter untuk kembali ke menu...${NC}"
        read
        return
    fi
    
    if [ -f "pterodactyl-optimizer.sh" ]; then
        bash pterodactyl-optimizer.sh
    else
        echo -e "${RED}[ERROR]${NC} File pterodactyl-optimizer.sh tidak ditemukan!"
    fi
    
    echo ""
    echo -e "${GREEN}Tekan Enter untuk kembali ke menu...${NC}"
    read
}

# Function: Check Status
check_status() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         SYSTEM STATUS & MONITORING                        ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${PURPLE}=== PANEL SERVICES ===${NC}"
    systemctl is-active --quiet nginx && echo -e "${GREEN}✓${NC} Nginx: Running" || echo -e "${RED}✗${NC} Nginx: Stopped"
    systemctl is-active --quiet php8.2-fpm && echo -e "${GREEN}✓${NC} PHP-FPM: Running" || echo -e "${RED}✗${NC} PHP-FPM: Stopped"
    systemctl is-active --quiet mariadb && echo -e "${GREEN}✓${NC} MariaDB: Running" || echo -e "${RED}✗${NC} MariaDB: Stopped"
    systemctl is-active --quiet redis-server && echo -e "${GREEN}✓${NC} Redis: Running" || echo -e "${RED}✗${NC} Redis: Stopped"
    systemctl is-active --quiet pteroq && echo -e "${GREEN}✓${NC} Queue Worker: Running" || echo -e "${RED}✗${NC} Queue Worker: Stopped"
    
    echo ""
    echo -e "${PURPLE}=== WINGS SERVICE ===${NC}"
    if command -v wings &> /dev/null; then
        systemctl is-active --quiet wings && echo -e "${GREEN}✓${NC} Wings: Running" || echo -e "${RED}✗${NC} Wings: Stopped"
        if systemctl is-active --quiet docker; then
            echo -e "${GREEN}✓${NC} Docker: Running"
        else
            echo -e "${RED}✗${NC} Docker: Stopped"
        fi
    else
        echo -e "${YELLOW}⚠${NC} Wings: Not Installed"
    fi
    
    echo ""
    echo -e "${PURPLE}=== RESOURCE USAGE ===${NC}"
    echo "CPU: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')"
    echo "RAM: $(free -m | awk 'NR==2{printf "%.2f%% (%dMB / %dMB)", $3*100/$2, $3, $2 }')"
    echo "Disk: $(df -h / | awk 'NR==2{printf "%s (%s / %s)", $5, $3, $2}')"
    
    if command -v docker &> /dev/null; then
        echo ""
        echo -e "${PURPLE}=== DOCKER CONTAINERS ===${NC}"
        CONTAINER_COUNT=$(docker ps -q | wc -l)
        echo "Running Containers: $CONTAINER_COUNT"
        if [ $CONTAINER_COUNT -gt 0 ]; then
            docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        fi
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
        echo -e "${YELLOW}⚠${NC} Database backup skipped"
    fi
    
    echo ""
    echo -e "${CYAN}[3/4]${NC} Backup configurations..."
    cp /var/www/pterodactyl/.env $BACKUP_DIR/ 2>/dev/null
    cp /etc/nginx/sites-available/pterodactyl.conf $BACKUP_DIR/ 2>/dev/null
    cp /etc/pterodactyl/config.yml $BACKUP_DIR/ 2>/dev/null
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
- .env (Panel environment)
- pterodactyl.conf (Nginx config)
- config.yml (Wings config)
EOF
    
    echo -e "${GREEN}✓${NC} Backup info created"
    
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✓ Backup berhasil dibuat!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Lokasi backup: $BACKUP_DIR"
    
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
    
    if [ -f "fix-common-issues.sh" ]; then
        bash fix-common-issues.sh
    else
        echo -e "${YELLOW}Pilih masalah yang ingin diperbaiki:${NC}"
        echo ""
        echo -e "${CYAN}[1]${NC} Fix Panel Permissions"
        echo -e "${CYAN}[2]${NC} Restart All Panel Services"
        echo -e "${CYAN}[3]${NC} Clear All Caches"
        echo -e "${CYAN}[4]${NC} Fix Queue Worker"
        echo -e "${CYAN}[5]${NC} Restart Wings"
        echo -e "${CYAN}[6]${NC} View Panel Errors"
        echo -e "${CYAN}[7]${NC} View Wings Logs"
        echo -e "${CYAN}[8]${NC} Kembali ke Menu Utama"
        echo ""
        echo -n -e "${GREEN}Pilih [1-8]: ${NC}"
        read -r choice
        
        case $choice in
            1)
                cd /var/www/pterodactyl
                chown -R www-data:www-data *
                chmod -R 755 storage bootstrap/cache
                echo -e "${GREEN}✓${NC} Permissions fixed"
                ;;
            2)
                systemctl restart php8.2-fpm nginx mariadb redis-server pteroq
                echo -e "${GREEN}✓${NC} All services restarted"
                ;;
            3)
                cd /var/www/pterodactyl
                php artisan cache:clear
                php artisan config:clear
                php artisan route:clear
                php artisan view:clear
                echo -e "${GREEN}✓${NC} Caches cleared"
                ;;
            4)
                systemctl restart pteroq
                echo -e "${GREEN}✓${NC} Queue worker restarted"
                ;;
            5)
                systemctl restart wings
                echo -e "${GREEN}✓${NC} Wings restarted"
                ;;
            6)
                tail -n 50 /var/log/nginx/pterodactyl.app-error.log
                ;;
            7)
                journalctl -u wings -n 50
                ;;
            8)
                return
                ;;
        esac
    fi
    
    echo ""
    echo -e "${GREEN}Tekan Enter untuk kembali ke menu...${NC}"
    read
}

# Function: View Documentation
view_docs() {
    clear
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         DOKUMENTASI                                       ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo "Dokumentasi tersedia:"
    echo ""
    [ -f "README.md" ] && echo -e "${GREEN}✓${NC} README.md - Dokumentasi utama"
    [ -f "CARA-INSTALASI.md" ] && echo -e "${GREEN}✓${NC} CARA-INSTALASI.md - Panduan instalasi"
    [ -f "TROUBLESHOOTING.md" ] && echo -e "${GREEN}✓${NC} TROUBLESHOOTING.md - Panduan troubleshooting"
    echo ""
    echo "Dokumentasi online:"
    echo "- Panel: https://pterodactyl.io/panel/1.0/getting_started.html"
    echo "- Wings: https://pterodactyl.io/wings/1.0/installing.html"
    echo "- Discord: https://discord.gg/pterodactyl"
    
    echo ""
    echo -e "${GREEN}Tekan Enter untuk kembali ke menu...${NC}"
    read
}

# Main loop
while true; do
    clear
    echo -e "${CYAN}"
    cat << "EOF"
|===========================================================|
-                                                          -
 -           .     █▀▀  █░█  █░░  █░░  █▄█          .          -
-               .  █▀░  █▄█  █▄▄  █▄▄  ░█░             .      -
  -                                               .            -
-                 .    █▀▀  █▀█  █▀█                  .      -
  -              .     █▀░  █▄█  █▀▄              .           -
-                                                  .       -
  -    █▀█  ▀█▀  █▀▀  █▀█  █▀█  █▀▄  ▄▀█  █▀▀  ▀█▀  █▄█       -
-      █▀▀  ░█░  ██▄  █▀▄  █▄█  █▄▀  █▀█  █▄▄  ░█░  ░█░      -  
  -                                                           -        
-         CREATED BY LUTFIALIFOFC-DROID                   -    
  -     THIS SCRIPT SUPPORT FOR UBUNTU 24.04 ONLY             -
-               SCRIPT VERSION 1.0                        -
|============================================================|
EOF
    echo -e "${NC}"
    
    show_menu
    read -r choice
    
    case $choice in
        1) install_panel ;;
        2) optimize_panel ;;
        3) update_panel ;;
        4) install_wings ;;
        5) manage_wings ;;
        6) configure_wings ;;
        7) check_status ;;
        8) backup_panel ;;
        9) troubleshooting ;;
        10) view_docs ;;
        11) 
            clear
            echo -e "${GREEN}Terima kasih telah menggunakan Pterodactyl Auto Installer!${NC}"
            echo ""
            exit 0
            ;;
        *)
            echo -e "${RED}Pilihan tidak valid. Silakan pilih 1-11.${NC}"
            sleep 2
            ;;
    esac
done
