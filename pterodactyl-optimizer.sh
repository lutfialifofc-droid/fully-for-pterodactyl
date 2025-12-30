#!/bin/bash

#############################################
# Pterodactyl Panel Optimizer
# Ubuntu 24.04 LTS + Nginx
# Optimizes existing Pterodactyl installation
#############################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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
   print_error "This script must be run as root (use sudo)"
   exit 1
fi

# Check if Pterodactyl is installed
if [ ! -d "/var/www/pterodactyl" ]; then
    print_error "Pterodactyl Panel not found at /var/www/pterodactyl"
    exit 1
fi

print_info "Starting Pterodactyl Panel Optimization..."
echo ""

# Backup current configuration
print_info "Creating backup..."
BACKUP_DIR="/root/pterodactyl-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p $BACKUP_DIR
cp -r /var/www/pterodactyl/.env $BACKUP_DIR/
cp -r /etc/nginx/sites-available/pterodactyl.conf $BACKUP_DIR/ 2>/dev/null || true
cp -r /etc/php/8.2/fpm/pool.d/www.conf $BACKUP_DIR/ 2>/dev/null || true
print_success "Backup created at $BACKUP_DIR"

# Get system resources
TOTAL_RAM=$(free -m | awk '/^Mem:/{print $2}')
CPU_CORES=$(nproc)

print_info "System Resources Detected:"
echo "  - RAM: ${TOTAL_RAM}MB"
echo "  - CPU Cores: ${CPU_CORES}"
echo ""

# Calculate optimal values
if [ $TOTAL_RAM -lt 2048 ]; then
    PHP_MAX_CHILDREN=25
    PHP_START_SERVERS=5
    PHP_MIN_SPARE=3
    PHP_MAX_SPARE=10
    NGINX_WORKER_CONNECTIONS=1024
    MYSQL_INNODB_BUFFER=256M
    REDIS_MAXMEMORY=128mb
elif [ $TOTAL_RAM -lt 4096 ]; then
    PHP_MAX_CHILDREN=50
    PHP_START_SERVERS=10
    PHP_MIN_SPARE=5
    PHP_MAX_SPARE=20
    NGINX_WORKER_CONNECTIONS=2048
    MYSQL_INNODB_BUFFER=512M
    REDIS_MAXMEMORY=256mb
elif [ $TOTAL_RAM -lt 8192 ]; then
    PHP_MAX_CHILDREN=100
    PHP_START_SERVERS=20
    PHP_MIN_SPARE=10
    PHP_MAX_SPARE=40
    NGINX_WORKER_CONNECTIONS=4096
    MYSQL_INNODB_BUFFER=1G
    REDIS_MAXMEMORY=512mb
else
    PHP_MAX_CHILDREN=150
    PHP_START_SERVERS=30
    PHP_MIN_SPARE=15
    PHP_MAX_SPARE=60
    NGINX_WORKER_CONNECTIONS=8192
    MYSQL_INNODB_BUFFER=2G
    REDIS_MAXMEMORY=1gb
fi

# Optimize PHP-FPM
print_info "Optimizing PHP-FPM configuration..."
cat > /etc/php/8.2/fpm/pool.d/www.conf <<EOF
[www]
user = www-data
group = www-data
listen = /run/php/php8.2-fpm.sock
listen.owner = www-data
listen.group = www-data
listen.mode = 0660

; Process Manager Settings
pm = dynamic
pm.max_children = ${PHP_MAX_CHILDREN}
pm.start_servers = ${PHP_START_SERVERS}
pm.min_spare_servers = ${PHP_MIN_SPARE}
pm.max_spare_servers = ${PHP_MAX_SPARE}
pm.max_requests = 1000
pm.process_idle_timeout = 10s

; Performance Tuning
request_terminate_timeout = 300s
request_slowlog_timeout = 10s
slowlog = /var/log/php8.2-fpm-slow.log

; PHP Settings
php_admin_value[upload_max_filesize] = 100M
php_admin_value[post_max_size] = 100M
php_admin_value[memory_limit] = 256M
php_admin_value[max_execution_time] = 300
php_admin_value[max_input_time] = 300
php_admin_value[max_input_vars] = 5000

; OPcache Settings
php_admin_value[opcache.enable] = 1
php_admin_value[opcache.memory_consumption] = 256
php_admin_value[opcache.interned_strings_buffer] = 16
php_admin_value[opcache.max_accelerated_files] = 10000
php_admin_value[opcache.revalidate_freq] = 2
php_admin_value[opcache.fast_shutdown] = 1
php_admin_value[opcache.enable_cli] = 0
php_admin_value[opcache.save_comments] = 1
php_admin_value[opcache.validate_timestamps] = 1

; Realpath Cache
php_admin_value[realpath_cache_size] = 4096K
php_admin_value[realpath_cache_ttl] = 600

; Session Settings
php_admin_value[session.save_handler] = redis
php_admin_value[session.save_path] = "tcp://127.0.0.1:6379"
php_admin_value[session.gc_maxlifetime] = 7200

; Security
php_admin_flag[expose_php] = off
php_admin_flag[display_errors] = off
php_admin_flag[log_errors] = on
php_admin_value[error_log] = /var/log/php8.2-fpm-error.log
EOF

print_success "PHP-FPM optimized"

# Optimize PHP CLI settings
print_info "Optimizing PHP CLI configuration..."
cat > /etc/php/8.2/cli/conf.d/99-pterodactyl.ini <<EOF
memory_limit = 512M
max_execution_time = 0
max_input_time = -1
upload_max_filesize = 100M
post_max_size = 100M
EOF

print_success "PHP CLI optimized"

# Optimize Nginx
print_info "Optimizing Nginx configuration..."

# Main Nginx configuration
cat > /etc/nginx/nginx.conf <<EOF
user www-data;
worker_processes ${CPU_CORES};
worker_rlimit_nofile 65535;
pid /run/nginx.pid;

events {
    worker_connections ${NGINX_WORKER_CONNECTIONS};
    use epoll;
    multi_accept on;
}

http {
    # Basic Settings
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    keepalive_requests 100;
    types_hash_max_size 2048;
    server_tokens off;
    client_max_body_size 100M;
    client_body_buffer_size 128k;
    client_header_buffer_size 1k;
    large_client_header_buffers 4 16k;

    # Timeouts
    client_body_timeout 12;
    client_header_timeout 12;
    send_timeout 10;
    reset_timedout_connection on;

    # MIME
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # Logging
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log warn;

    # Gzip Compression
    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types text/plain text/css text/xml text/javascript application/json application/javascript application/xml+rss application/rss+xml font/truetype font/opentype application/vnd.ms-fontobject image/svg+xml;
    gzip_disable "msie6";
    gzip_min_length 256;

    # Brotli Compression (if available)
    # brotli on;
    # brotli_comp_level 6;
    # brotli_types text/plain text/css text/xml text/javascript application/json application/javascript application/xml+rss application/rss+xml font/truetype font/opentype application/vnd.ms-fontobject image/svg+xml;

    # FastCGI Cache
    fastcgi_cache_path /var/cache/nginx/fastcgi levels=1:2 keys_zone=PTERODACTYL:100m inactive=60m max_size=512m;
    fastcgi_cache_key "\$scheme\$request_method\$host\$request_uri";
    fastcgi_cache_use_stale error timeout invalid_header http_500;
    fastcgi_ignore_headers Cache-Control Expires Set-Cookie;

    # Rate Limiting
    limit_req_zone \$binary_remote_addr zone=pterolimit:10m rate=10r/s;
    limit_conn_zone \$binary_remote_addr zone=pteroconn:10m;

    # Virtual Host Configs
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
EOF

# Create cache directory
mkdir -p /var/cache/nginx/fastcgi
chown -R www-data:www-data /var/cache/nginx

print_success "Nginx optimized"

# Optimize MariaDB/MySQL
print_info "Optimizing MariaDB configuration..."
cat > /etc/mysql/mariadb.conf.d/99-pterodactyl.cnf <<EOF
[mysqld]
# InnoDB Settings
innodb_buffer_pool_size = ${MYSQL_INNODB_BUFFER}
innodb_log_file_size = 256M
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DIRECT
innodb_file_per_table = 1
innodb_buffer_pool_instances = ${CPU_CORES}

# Query Cache (disabled in MariaDB 10.5+, but kept for compatibility)
query_cache_type = 0
query_cache_size = 0

# Connection Settings
max_connections = 200
max_connect_errors = 1000
connect_timeout = 10
wait_timeout = 600
interactive_timeout = 600

# Buffer Settings
join_buffer_size = 2M
sort_buffer_size = 2M
read_buffer_size = 1M
read_rnd_buffer_size = 2M
tmp_table_size = 64M
max_heap_table_size = 64M

# Thread Settings
thread_cache_size = 50
thread_stack = 256K

# Table Settings
table_open_cache = 4000
table_definition_cache = 2000

# Logging
slow_query_log = 1
slow_query_log_file = /var/log/mysql/mysql-slow.log
long_query_time = 2
log_queries_not_using_indexes = 0

# Binary Logging (optional, disable if not needed)
# log_bin = /var/log/mysql/mysql-bin.log
# expire_logs_days = 7
# max_binlog_size = 100M

# Character Set
character_set_server = utf8mb4
collation_server = utf8mb4_unicode_ci

# Performance Schema
performance_schema = ON
EOF

print_success "MariaDB optimized"

# Optimize Redis
print_info "Optimizing Redis configuration..."
cat >> /etc/redis/redis.conf <<EOF

# Pterodactyl Optimizations
maxmemory ${REDIS_MAXMEMORY}
maxmemory-policy allkeys-lru
save ""
appendonly no
tcp-backlog 511
timeout 300
tcp-keepalive 60
loglevel notice
databases 16
stop-writes-on-bgsave-error no
rdbcompression yes
rdbchecksum yes
EOF

print_success "Redis optimized"

# Optimize Pterodactyl Panel
print_info "Optimizing Pterodactyl Panel..."
cd /var/www/pterodactyl

# Clear and optimize caches
php artisan down
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Optimize autoloader and cache
COMPOSER_ALLOW_SUPERUSER=1 composer install --optimize-autoloader --no-dev
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Optimize database
php artisan migrate --force
php artisan db:seed --force

php artisan up

print_success "Pterodactyl Panel optimized"

# Set proper permissions
print_info "Setting proper permissions..."
chown -R www-data:www-data /var/www/pterodactyl
chmod -R 755 /var/www/pterodactyl
chmod -R 755 /var/www/pterodactyl/storage
chmod -R 755 /var/www/pterodactyl/bootstrap/cache
print_success "Permissions set"

# Restart services
print_info "Restarting services..."
systemctl restart php8.2-fpm
systemctl restart nginx
systemctl restart mariadb
systemctl restart redis-server
systemctl restart pteroq.service
print_success "Services restarted"

# System optimizations
print_info "Applying system-level optimizations..."

# Increase file limits
cat >> /etc/security/limits.conf <<EOF
* soft nofile 65535
* hard nofile 65535
www-data soft nofile 65535
www-data hard nofile 65535
EOF

# Kernel optimizations
cat > /etc/sysctl.d/99-pterodactyl.conf <<EOF
# Network Performance
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 5000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_tw_reuse = 1

# Memory Management
vm.swappiness = 10
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5

# File System
fs.file-max = 2097152
fs.inotify.max_user_watches = 524288
EOF

sysctl -p /etc/sysctl.d/99-pterodactyl.conf

print_success "System optimizations applied"

# Setup monitoring script
print_info "Creating monitoring script..."
cat > /usr/local/bin/pterodactyl-monitor.sh <<'EOF'
#!/bin/bash

echo "=== Pterodactyl Panel Status ==="
echo ""
echo "Services Status:"
systemctl is-active --quiet nginx && echo "✓ Nginx: Running" || echo "✗ Nginx: Stopped"
systemctl is-active --quiet php8.2-fpm && echo "✓ PHP-FPM: Running" || echo "✗ PHP-FPM: Stopped"
systemctl is-active --quiet mariadb && echo "✓ MariaDB: Running" || echo "✗ MariaDB: Stopped"
systemctl is-active --quiet redis-server && echo "✓ Redis: Running" || echo "✗ Redis: Stopped"
systemctl is-active --quiet pteroq && echo "✓ Queue Worker: Running" || echo "✗ Queue Worker: Stopped"

echo ""
echo "Resource Usage:"
echo "CPU: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')"
echo "RAM: $(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')"
echo "Disk: $(df -h / | awk 'NR==2{print $5}')"

echo ""
echo "PHP-FPM Pool Status:"
systemctl status php8.2-fpm | grep "active"

echo ""
echo "Recent Errors (last 10):"
tail -n 10 /var/log/nginx/pterodactyl.app-error.log 2>/dev/null || echo "No errors found"
EOF

chmod +x /usr/local/bin/pterodactyl-monitor.sh
print_success "Monitoring script created at /usr/local/bin/pterodactyl-monitor.sh"

# Performance test
print_info "Running performance test..."
echo ""
echo "Testing PHP-FPM performance..."
php -v
php -i | grep "opcache.enable"

echo ""
echo "Testing Nginx configuration..."
nginx -t

echo ""
echo "Testing database connection..."
mysql -e "SELECT VERSION();" 2>/dev/null && print_success "Database connection OK" || print_error "Database connection failed"

echo ""
echo "Testing Redis connection..."
redis-cli ping 2>/dev/null && print_success "Redis connection OK" || print_error "Redis connection failed"

# Generate optimization report
print_info "Generating optimization report..."
cat > /root/pterodactyl-optimization-report.txt <<EOF
Pterodactyl Panel Optimization Report
Generated: $(date)
========================================

System Resources:
- Total RAM: ${TOTAL_RAM}MB
- CPU Cores: ${CPU_CORES}

Applied Optimizations:
- PHP-FPM max children: ${PHP_MAX_CHILDREN}
- PHP-FPM start servers: ${PHP_START_SERVERS}
- Nginx worker connections: ${NGINX_WORKER_CONNECTIONS}
- MySQL InnoDB buffer pool: ${MYSQL_INNODB_BUFFER}
- Redis max memory: ${REDIS_MAXMEMORY}

Backup Location: ${BACKUP_DIR}

Monitoring:
- Run 'pterodactyl-monitor.sh' to check system status
- Logs location: /var/log/nginx/pterodactyl.app-*.log

Performance Tips:
1. Monitor resource usage regularly
2. Adjust PHP-FPM pool settings based on traffic
3. Enable CDN for static assets
4. Consider using Redis for session storage
5. Regular database optimization with 'mysqlcheck'

Next Steps:
1. Test panel functionality
2. Monitor error logs
3. Adjust settings based on actual usage
4. Setup automated backups
========================================
EOF

print_success "Optimization report saved to /root/pterodactyl-optimization-report.txt"

echo ""
echo "=========================================="
print_success "Pterodactyl Panel Optimization Complete!"
echo "=========================================="
echo ""
echo "Summary:"
echo "  ✓ PHP-FPM optimized for ${TOTAL_RAM}MB RAM"
echo "  ✓ Nginx configured with ${CPU_CORES} workers"
echo "  ✓ MariaDB tuned with ${MYSQL_INNODB_BUFFER} buffer pool"
echo "  ✓ Redis configured with ${REDIS_MAXMEMORY} max memory"
echo "  ✓ System kernel parameters optimized"
echo "  ✓ Monitoring script installed"
echo ""
echo "Useful Commands:"
echo "  - Check status: pterodactyl-monitor.sh"
echo "  - View report: cat /root/pterodactyl-optimization-report.txt"
echo "  - Restore backup: cp -r ${BACKUP_DIR}/* /original/locations/"
echo ""
echo "Recommended: Reboot the server for all optimizations to take full effect"
echo "=========================================="
