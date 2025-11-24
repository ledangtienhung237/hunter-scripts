cat > ~/setup_dst_dependencies.sh << 'EOF'
#!/bin/bash
set -euo pipefail

# ===== COLOR LOG =====
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
NC="\033[0m"

OK()   { echo -e "${GREEN}[OK]${NC} $1"; }
WARN() { echo -e "${YELLOW}[WARN]${NC} $1"; }
ERR()  { echo -e "${RED}[ERR]${NC} $1"; }

# ===== ROOT CHECK =====
if [ "$EUID" -ne 0"; then
    ERR "Hãy chạy script bằng: sudo ./setup_dst_dependencies.sh"
    exit 1
fi

echo -e "${GREEN}=============================="
echo -e " SAFE DST DEPENDENCY INSTALL  "
echo -e "==============================${NC}"

# ===== 0. CHẶN REBOOT PENDING =====
if [ -f /var/run/reboot-required ]; then
    WARN "Hệ thống yêu cầu reboot trước khi tiếp tục!"
    WARN "Chạy lệnh: sudo reboot"
    exit 1
fi

# ===== 1. UPDATE PACKAGE LIST =====
apt update -y
OK "Package list updated"

# ===== 2. ENABLE i386 ARCHITECTURE =====
if ! dpkg --print-foreign-architectures | grep -q i386; then
    dpkg --add-architecture i386
    apt update -y
fi
OK "i386 enabled"

# ===== 3. INSTALL 32-BIT DEPENDENCIES =====
apt install -y \
    libc6:i386 \
    libc6-i386 \
    libstdc++6:i386 \
    libgcc-s1:i386 \
    libbz2-1.0:i386 \
    libncurses6:i386 \
    libtinfo6:i386 \
    libunistring5:i386 \
    libidn2-0:i386 \
    lib32gcc-s1 \
    lib32stdc++6 \
    wget \
    screen \
    tar \
    ca-certificates
OK "Dependency SteamCMD đã cài xong"

# ===== 4. UDP OPTIMIZATION =====
cat > /etc/sysctl.d/99-dst-udp.conf << 'EOT'
net.core.rmem_max = 26214400
net.core.wmem_max = 26214400
net.core.netdev_max_backlog = 4096
net.ipv4.udp_rmem_min = 16384
net.ipv4.udp_wmem_min = 16384
EOT

sysctl --system > /dev/null
OK "UDP tuning applied"

echo -e "${GREEN}=============================="
echo -e " DST DEPENDENCIES READY "
echo -e "==============================${NC}"
EOF




Chạy:

chmod +x ~/setup_dst_dependencies.sh
sudo ~/setup_dst_dependencies.sh
