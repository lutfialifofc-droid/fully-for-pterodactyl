#!/bin/bash

#############################################
# Pterodactyl Common Issues Fixer
# Fix Application Key & MySQL Access Issues
#############################################

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_error "Script ini harus dijalankan sebagai root (gunakan sudo)"
   exit 1
fi

clear
echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║         PTERODACTYL COMMON ISSUES FIXER                   ║
║         Fix Application Key & MySQL Access                ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Main menu
echo -e "${YELLOW}Pilih masalah yang ingin diperbaiki:${NC}"
echo ""
echo -e "${CYAN}[1]${NC} Fix Application Key (APP_KEY empty/not set)"
echo -e "${CYAN}[2]${NC} Fix MySQL Access Denied (ERROR 1045)"
echo -e "${CYAN}[3]${NC} Fix Database Connection Issues"
echo -e "${CYAN}[4]${NC} Fix All Permissions"
echo -e "${CYAN}[5]${NC} Complete System Check & Fix"
echo -e "${CYAN}[6]${NC} Exit"
echo ""
echo -n -e "${GREEN}Pilih [1-6]: ${NC}"
read -r choice

case $choice in
    1)
        # Fix Application Key
        clear
        echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
        echo -e "${BLUE}FIX APPLICATION KEY${NC}"
        echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
        echo ""
        
        if [ ! -d "/var/www/pterodactyl" ]; then
            print_error "Pterodactyl tidak ditemukan di /var/www/pterodactyl"
            exit 1
        fi
        
        cd /var/www/pterodactyl
        
        print_info "Checking current APP_KEY..."
        if grep -q "APP_KEY=base64:" .env; then
            print_warning "APP_KEY sudah ada. Ingin regenerate? (y/n)"
            read -r response
            if [[ ! "$response" =~ ^[Yy]$ ]]; then
                exit 0
            fi
        fi
        
        print_info "Backing up .env file..."
        cp .env .env.backup-$(date +%Y%m%d-%H%M%S)
        print_success "Backup created"
        
        print_info "Clearing cache..."
        php artisan config:clear
        php artisan cache:clear
        
        print_info "Generating new application key..."
        php artisan key:generate --force
        
        print_info "Verifying key..."
        if grep -q "APP_KEY=base64:" .env; then
            print_success "Application key generated successfully!"
            echo ""
            echo "Current APP_KEY:"
            grep "APP_KEY" .env
            echo ""
            
            print_info "Restarting services..."
            systemctl restart php8.2-fpm
            systemctl restart nginx
            print_success "Services restarted"
            
            echo ""
            print_success "Application key fixed! Silakan coba akses panel Anda."
        else
            print_error "Failed to generate application key"
            echo ""
            echo "Manual fix:"
            echo "1. cd /var/www/pterodactyl"
            echo "2. php artisan key:generate --force"
            echo "3. Check .env file: nano .env"
        fi
        ;;
        
    2)
        # Fix MySQL Access
        clear
        echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
        echo -e "${BLUE}FIX MYSQL ACCESS DENIED${NC}"
        echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
        echo ""
        
        print_warning "Metode ini akan reset password MySQL root"
        echo -n "Lanjutkan? (y/n): "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            exit 0
        fi
        
        echo ""
        read -sp "Masukkan password MySQL root BARU: " NEW_MYSQL_PASSWORD
        echo ""
        read -sp "Konfirmasi password: " CONFIRM_PASSWORD
        echo ""
        
        if [ "$NEW_MYSQL_PASSWORD" != "$CONFIRM_PASSWORD" ]; then
            print_error "Password tidak cocok!"
            exit 1
        fi
        
        print_info "Stopping MySQL..."
        systemctl stop mariadb
        
        print_info "Starting MySQL in safe mode..."
        mysqld_safe --skip-grant-tables &
        SAFE_PID=$!
        
        sleep 5
        
        print_info "Resetting root password..."
        mysql -u root <<EOF
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${NEW_MYSQL_PASSWORD}';
FLUSH PRIVILEGES;
EOF
        
        print_info "Stopping safe mode..."
        pkill mysqld_safe
        pkill mysqld
        sleep 2
        
        print_info "Starting MySQL normally..."
        systemctl start mariadb
        sleep 2
        
        print_info "Testing connection..."
        if mysql -u root -p"${NEW_MYSQL_PASSWORD}" -e "SELECT 1;" &>/dev/null; then
            print_success "MySQL root password berhasil direset!"
            echo ""
            echo "Password baru: ${NEW_MYSQL_PASSWORD}"
            echo ""
            print_warning "SIMPAN PASSWORD INI!"
            echo ""
            
            # Update .env if exists
            if [ -f "/var/www/pterodactyl/.env" ]; then
                print_info "Ingin update password di .env Pterodactyl? (y/n)"
                read -r update_env
                if [[ "$update_env" =~ ^[Yy]$ ]]; then
                    read -sp "Masukkan password database Pterodactyl: " PANEL_PASSWORD
                    echo ""
                    
                    # Test pterodactyl user
                    mysql -u root -p"${NEW_MYSQL_PASSWORD}" <<EOF
GRANT ALL PRIVILEGES ON panel.* TO 'pterodactyl'@'127.0.0.1' IDENTIFIED BY '${PANEL_PASSWORD}';
FLUSH PRIVILEGES;
EOF
                    
                    # Update .env
                    sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=${PANEL_PASSWORD}/" /var/www/pterodactyl/.env
                    
                    cd /var/www/pterodactyl
                    php artisan config:clear
                    
                    print_success ".env updated"
                fi
            fi
        else
            print_error "Failed to reset password. Coba metode manual."
            echo ""
            echo "Manual fix:"
            echo "1. sudo systemctl stop mariadb"
            echo "2. sudo mysqld_safe --skip-grant-tables &"
            echo "3. mysql -u root"
            echo "4. FLUSH PRIVILEGES;"
            echo "5. ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';"
            echo "6. FLUSH PRIVILEGES;"
            echo "7. EXIT;"
            echo "8. sudo pkill mysqld"
            echo "9. sudo systemctl start mariadb"
        fi
        ;;
        
    3)
        # Fix Database Connection
        clear
        echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
        echo -e "${BLUE}FIX DATABASE CONNECTION${NC}"
        echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
        echo ""
        
        if [ ! -f "/var/www/pterodactyl/.env" ]; then
            print_error ".env file tidak ditemukan"
            exit 1
        fi
        
        print_info "Checking database configuration..."
        
        DB_HOST=$(grep "DB_HOST=" /var/www/pterodactyl/.env | cut -d '=' -f2)
        DB_DATABASE=$(grep "DB_DATABASE=" /var/www/pterodactyl/.env | cut -d '=' -f2)
        DB_USERNAME=$(grep "DB_USERNAME=" /var/www/pterodactyl/.env | cut -d '=' -f2)
        
        echo "Current config:"
        echo "  Host: $DB_HOST"
        echo "  Database: $DB_DATABASE"
        echo "  Username: $DB_USERNAME"
        echo ""
        
        read -sp "Masukkan MySQL root password: " MYSQL_ROOT_PASS
        echo ""
        read -sp "Masukkan password untuk user $DB_USERNAME: " DB_PASSWORD
        echo ""
        
        print_info "Testing MySQL connection..."
        if ! mysql -u root -p"${MYSQL_ROOT_PASS}" -e "SELECT 1;" &>/dev/null; then
            print_error "Cannot connect to MySQL with root password"
            exit 1
        fi
        
        print_success "MySQL root connection OK"
        
        print_info "Checking database..."
        mysql -u root -p"${MYSQL_ROOT_PASS}" <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_DATABASE};
EOF
        
        print_info "Checking user..."
        mysql -u root -p"${MYSQL_ROOT_PASS}" <<EOF
CREATE USER IF NOT EXISTS '${DB_USERNAME}'@'${DB_HOST}' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_DATABASE}.* TO '${DB_USERNAME}'@'${DB_HOST}';
FLUSH PRIVILEGES;
EOF
        
        print_info "Testing user connection..."
        if mysql -u "${DB_USERNAME}" -p"${DB_PASSWORD}" -h "${DB_HOST}" "${DB_DATABASE}" -e "SELECT 1;" &>/dev/null; then
            print_success "Database user connection OK"
            
            # Update .env
            sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=${DB_PASSWORD}/" /var/www/pterodactyl/.env
            
            cd /var/www/pterodactyl
            php artisan config:clear
            php artisan cache:clear
            
            print_success "Database connection fixed!"
        else
            print_error "User connection failed"
        fi
        ;;
        
    4)
        # Fix Permissions
        clear
        echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
        echo -e "${BLUE}FIX ALL PERMISSIONS${NC}"
        echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
        echo ""
        
        if [ ! -d "/var/www/pterodactyl" ]; then
            print_error "Pterodactyl tidak ditemukan"
            exit 1
        fi
        
        print_info "Fixing ownership..."
        chown -R www-data:www-data /var/www/pterodactyl
        print_success "Ownership fixed"
        
        print_info "Fixing permissions..."
        chmod -R 755 /var/www/pterodactyl
        chmod -R 755 /var/www/pterodactyl/storage
        chmod -R 755 /var/www/pterodactyl/bootstrap/cache
        print_success "Permissions fixed"
        
        print_info "Clearing cache..."
        cd /var/www/pterodactyl
        php artisan cache:clear
        php artisan config:clear
        php artisan route:clear
        php artisan view:clear
        print_success "Cache cleared"
        
        print_info "Restarting services..."
        systemctl restart php8.2-fpm
        systemctl restart nginx
        print_success "Services restarted"
        
        echo ""
        print_success "All permissions fixed!"
        ;;
        
    5)
        # Complete Check
        clear
        echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
        echo -e "${BLUE}COMPLETE SYSTEM CHECK & FIX${NC}"
        echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
        echo ""
        
        print_info "Running complete system check..."
        echo ""
        
        # Check Pterodactyl
        if [ -d "/var/www/pterodactyl" ]; then
            print_success "Pterodactyl directory exists"
        else
            print_error "Pterodactyl directory not found"
            exit 1
        fi
        
        # Check services
        echo ""
        print_info "Checking services..."
        systemctl is-active --quiet nginx && print_success "Nginx running" || print_error "Nginx stopped"
        systemctl is-active --quiet php8.2-fpm && print_success "PHP-FPM running" || print_error "PHP-FPM stopped"
        systemctl is-active --quiet mariadb && print_success "MariaDB running" || print_error "MariaDB stopped"
        systemctl is-active --quiet redis-server && print_success "Redis running" || print_error "Redis stopped"
        systemctl is-active --quiet pteroq && print_success "Queue Worker running" || print_error "Queue Worker stopped"
        
        # Check APP_KEY
        echo ""
        print_info "Checking APP_KEY..."
        if grep -q "APP_KEY=base64:" /var/www/pterodactyl/.env; then
            print_success "APP_KEY is set"
        else
            print_warning "APP_KEY not set, generating..."
            cd /var/www/pterodactyl
            php artisan key:generate --force
            if grep -q "APP_KEY=base64:" .env; then
                print_success "APP_KEY generated"
            else
                print_error "Failed to generate APP_KEY"
            fi
        fi
        
        # Check permissions
        echo ""
        print_info "Checking permissions..."
        cd /var/www/pterodactyl
        chown -R www-data:www-data /var/www/pterodactyl
        chmod -R 755 storage bootstrap/cache
        print_success "Permissions fixed"
        
        # Clear cache
        echo ""
        print_info "Clearing cache..."
        php artisan cache:clear
        php artisan config:clear
        print_success "Cache cleared"
        
        # Restart services
        echo ""
        print_info "Restarting services..."
        systemctl restart php8.2-fpm
        systemctl restart nginx
        systemctl restart pteroq
        print_success "Services restarted"
        
        echo ""
        print_success "Complete system check finished!"
        echo ""
        echo "Next steps:"
        echo "1. Test panel access: https://your-domain.com"
        echo "2. Check logs if issues persist:"
        echo "   - tail -f /var/log/nginx/pterodactyl.app-error.log"
        echo "3. Run specific fix if needed (option 1-4)"
        ;;
        
    6)
        echo ""
        print_info "Exiting..."
        exit 0
        ;;
        
    *)
        print_error "Invalid option"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}Tekan Enter untuk keluar...${NC}"
read
