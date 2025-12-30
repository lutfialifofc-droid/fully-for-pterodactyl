#!/bin/bash

#############################################
# Pterodactyl Wings Auto Installer
# Ubuntu 24.04 LTS
# Wings (Daemon/Node) Installation
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
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root (use sudo)"
   exit 1
fi

# Check Ubuntu version
if ! grep -q "24.04" /etc/os-release; then
    print_warning "This script is designed for Ubuntu 24.04 LTS"
    read -p "Continue anyway? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

clear
echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   ██╗    ██╗██╗███╗   ██╗ ██████╗ ███████╗               ║
║   ██║    ██║██║████╗  ██║██╔════╝ ██╔════╝               ║
║   ██║ █╗ ██║██║██╔██╗ ██║██║  ███╗███████╗               ║
║   ██║███╗██║██║██║╚██╗██║██║   ██║╚════██║               ║
║   ╚███╔███╔╝██║██║ ╚████║╚██████╔╝███████║               ║
║    ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝               ║
║                                                           ║
║        Pterodactyl Wings - Auto Installer                ║
║                  Ubuntu 24.04 LTS                        ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

print_info "Starting Pterodactyl Wings Installation..."
echo ""

# Get user input
read -p "Enter your Panel URL (e.g., https://panel.example.com): " PANEL_URL
read -p "Enter FQDN for this node (e.g., node1.example.com): " NODE_FQDN

# Validate Panel URL
if [[ ! $PANEL_URL =~ ^https?:// ]]; then
    print_error "Panel URL must start with http:// or https://"
    exit 1
fi

# Update system
print_info "Updating system packages..."
apt update && apt upgrade -y

# Install required packages
print_info "Installing dependencies..."
apt install -y curl tar unzip

# Install Docker
print_info "Installing Docker..."
if ! command -v docker &> /dev/null; then
    # Add Docker's official GPG key
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    apt update
    
    # Install Docker packages
    apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Enable and start Docker
    systemctl enable docker
    systemctl start docker
    
    print_success "Docker installed successfully"
else
    print_success "Docker already installed"
fi

# Verify Docker installation
if docker --version &> /dev/null; then
    print_success "Docker version: $(docker --version)"
else
    print_error "Docker installation failed"
    exit 1
fi

# Enable swap (recommended for game servers)
print_info "Configuring swap..."
if [ ! -f /swapfile ]; then
    # Create 2GB swap file
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
    print_success "Swap configured (2GB)"
else
    print_success "Swap already configured"
fi

# Configure kernel parameters for game servers
print_info "Configuring kernel parameters..."
cat > /etc/sysctl.d/99-wings.conf <<EOF
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
fs.inotify.max_user_instances = 8192

# For game servers
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
EOF

sysctl -p /etc/sysctl.d/99-wings.conf
print_success "Kernel parameters configured"

# Create Wings directory
print_info "Creating Wings directory..."
mkdir -p /etc/pterodactyl
mkdir -p /var/lib/pterodactyl/volumes
mkdir -p /var/log/pterodactyl

# Download Wings
print_info "Downloading Wings..."
WINGS_VERSION=$(curl -s https://api.github.com/repos/pterodactyl/wings/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
print_info "Latest Wings version: $WINGS_VERSION"

curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64"
chmod +x /usr/local/bin/wings

# Verify Wings installation
if wings --version &> /dev/null; then
    print_success "Wings downloaded successfully: $(wings --version)"
else
    print_error "Wings download failed"
    exit 1
fi

# Create Wings systemd service
print_info "Creating Wings systemd service..."
cat > /etc/systemd/system/wings.service <<'EOF'
[Unit]
Description=Pterodactyl Wings Daemon
After=docker.service
Requires=docker.service
PartOf=docker.service

[Service]
User=root
WorkingDirectory=/etc/pterodactyl
LimitNOFILE=4096
PIDFile=/var/run/wings/daemon.pid
ExecStart=/usr/local/bin/wings
Restart=on-failure
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable wings

print_success "Wings service created"

# Configure firewall
print_info "Configuring firewall..."
if command -v ufw &> /dev/null; then
    ufw --force enable
    ufw allow 22/tcp
    ufw allow 8080/tcp
    ufw allow 2022/tcp
    ufw allow 443/tcp
    
    # Allow game server ports (default range)
    ufw allow 25565:25665/tcp
    ufw allow 25565:25665/udp
    
    print_success "Firewall configured"
else
    print_warning "UFW not installed, skipping firewall configuration"
fi

# SSL Certificate setup (optional but recommended)
print_info "Setting up SSL certificate..."
if [ ! -z "$NODE_FQDN" ]; then
    # Install certbot
    apt install -y certbot
    
    print_warning "To generate SSL certificate, you need to:"
    echo "1. Ensure $NODE_FQDN points to this server's IP"
    echo "2. Stop any service using port 80"
    echo "3. Run: certbot certonly --standalone -d $NODE_FQDN"
    echo ""
    read -p "Do you want to generate SSL certificate now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Stop any service on port 80
        systemctl stop nginx 2>/dev/null || true
        systemctl stop apache2 2>/dev/null || true
        
        certbot certonly --standalone -d $NODE_FQDN --non-interactive --agree-tos --email admin@$NODE_FQDN || {
            print_warning "SSL certificate generation failed. You can generate it later."
        }
    fi
fi

# Create example configuration
print_info "Creating example configuration..."
cat > /etc/pterodactyl/config.yml.example <<EOF
debug: false
uuid: YOUR_NODE_UUID_HERE
token_id: YOUR_TOKEN_ID_HERE
token: YOUR_TOKEN_HERE
api:
  host: 0.0.0.0
  port: 8080
  ssl:
    enabled: true
    cert: /etc/letsencrypt/live/${NODE_FQDN}/fullchain.pem
    key: /etc/letsencrypt/live/${NODE_FQDN}/privkey.pem
  upload_limit: 100
system:
  data: /var/lib/pterodactyl/volumes
  sftp:
    bind_port: 2022
allowed_mounts: []
remote: ${PANEL_URL}
EOF

print_success "Example configuration created"

# System optimization for game servers
print_info "Applying game server optimizations..."

# Increase file limits
cat >> /etc/security/limits.conf <<EOF
* soft nofile 65535
* hard nofile 65535
root soft nofile 65535
root hard nofile 65535
EOF

print_success "System optimizations applied"

# Create Wings management script
print_info "Creating Wings management script..."
cat > /usr/local/bin/wings-manager.sh <<'EOFSCRIPT'
#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}[✓]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }
print_info() { echo -e "${BLUE}[i]${NC} $1"; }

case "$1" in
    start)
        print_info "Starting Wings..."
        systemctl start wings
        print_success "Wings started"
        ;;
    stop)
        print_info "Stopping Wings..."
        systemctl stop wings
        print_success "Wings stopped"
        ;;
    restart)
        print_info "Restarting Wings..."
        systemctl restart wings
        print_success "Wings restarted"
        ;;
    status)
        systemctl status wings
        ;;
    logs)
        journalctl -u wings -f
        ;;
    update)
        print_info "Updating Wings..."
        systemctl stop wings
        curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64"
        chmod +x /usr/local/bin/wings
        systemctl start wings
        print_success "Wings updated to latest version"
        ;;
    configure)
        nano /etc/pterodactyl/config.yml
        ;;
    *)
        echo "Usage: wings-manager.sh {start|stop|restart|status|logs|update|configure}"
        exit 1
        ;;
esac
EOFSCRIPT

chmod +x /usr/local/bin/wings-manager.sh
print_success "Wings manager script created"

# Installation complete
echo ""
echo "=========================================="
print_success "Pterodactyl Wings Installation Complete!"
echo "=========================================="
echo ""
echo "Installation Summary:"
echo "  - Wings Version: $WINGS_VERSION"
echo "  - Docker: $(docker --version | cut -d' ' -f3)"
echo "  - Node FQDN: $NODE_FQDN"
echo "  - Panel URL: $PANEL_URL"
echo ""
echo "Next Steps:"
echo "=========================================="
echo "1. Go to your Panel: $PANEL_URL/admin/nodes"
echo "2. Create a new node or select existing node"
echo "3. Go to 'Configuration' tab"
echo "4. Copy the configuration and save it to:"
echo "   /etc/pterodactyl/config.yml"
echo ""
echo "5. Start Wings:"
echo "   systemctl start wings"
echo ""
echo "6. Check Wings status:"
echo "   systemctl status wings"
echo "   wings-manager.sh status"
echo ""
echo "Useful Commands:"
echo "  - Start Wings: wings-manager.sh start"
echo "  - Stop Wings: wings-manager.sh stop"
echo "  - Restart Wings: wings-manager.sh restart"
echo "  - View logs: wings-manager.sh logs"
echo "  - Update Wings: wings-manager.sh update"
echo "  - Edit config: wings-manager.sh configure"
echo ""
echo "Configuration file: /etc/pterodactyl/config.yml"
echo "Example config: /etc/pterodactyl/config.yml.example"
echo ""
echo "Firewall Ports Opened:"
echo "  - 8080/tcp (Wings API)"
echo "  - 2022/tcp (SFTP)"
echo "  - 25565-25665/tcp & udp (Game servers)"
echo ""
if [ -f "/etc/letsencrypt/live/${NODE_FQDN}/fullchain.pem" ]; then
    echo "SSL Certificate: ✓ Installed"
    echo "  - Cert: /etc/letsencrypt/live/${NODE_FQDN}/fullchain.pem"
    echo "  - Key: /etc/letsencrypt/live/${NODE_FQDN}/privkey.pem"
else
    echo "SSL Certificate: ✗ Not installed"
    echo "  Generate with: certbot certonly --standalone -d ${NODE_FQDN}"
fi
echo ""
echo "=========================================="
print_warning "IMPORTANT: Configure Wings before starting!"
echo "=========================================="
