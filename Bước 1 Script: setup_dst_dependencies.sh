cat > ~/setup_dst_dependencies.sh << 'EOF'
#!/bin/bash
set -euo pipefail

# ===============================
# Don't Starve Together Server
# DEPENDENCIES + UDP OPTIMIZATION
# ===============================

GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
NC="\033[0m"

LOG() { echo -e "${GREEN}[INFO]${NC} $1"; }
WARN() { echo -e "${YELLOW}[WARN]${NC} $1"; }
ERROR() { echo -e "${RED}[ERROR]${NC} $1"; }

check_root() {
    if [ "$EUID" -ne 0 ]; then
        ERROR "Script cần chạy với quyền root (sudo)."
        exit 1
    fi
}

check_success() {
    if [ $? -ne 0 ]; then
        ERROR "$1 FAILED — Dừng script!"
        exit 1
    else
        LOG "$1 thành công."
    fi
}

check_root

LOG "=============================="
LOG "  BẮT ĐẦU CÀI ĐẶT DEPENDENCY  "
LOG "=============================="

# -------------------------------
# 1. Update + Upgrade hệ thống
# -------------------------------
LOG "Cập nhật hệ thống..."
apt update -y && apt upgrade -y
check_success "Update + Upgrade"

# -------------------------------
# 2. Add kiến trúc 32-bit
# -------------------------------
LOG "Bật kiến trúc 32-bit (i386)..."
dpkg --add-architecture i386
check_success "Add architecture i386"

apt update -y
check_success "Update lần 2 sau khi thêm i386"

# -------------------------------
# 3. Cài dependency chính
# -------------------------------
LOG "Cài đặt dependency cần thiết (lib32gcc*, screen, wget, tar, ca-cert)..."
apt install -y lib32gcc-s1 lib32stdc++6 screen wget tar ca-certificates
check_success "Cài dependency DST + SteamCMD"

# -------------------------------
# 4. Kernel UDP Tuning (DST BOOST)
# -------------------------------
LOG "Áp dụng cấu hình kernel tối ưu UDP cho DST..."

cat > /etc/sysctl.d/99-dst-udp.conf << 'EOT'
# ===== DST UDP OPTIMIZATION =====
net.core.rmem_max = 26214400
net.core.wmem_max = 26214400
net.core.rmem_default = 26214400
net.core.wmem_default = 26214400
net.core.netdev_max_backlog = 4096
net.ipv4.udp_rmem_min = 16384
net.ipv4.udp_wmem_min = 16384
net.ipv4.udp_mem = 4096 87380 16777216
EOT

sysctl --system >/dev/null 2>&1
check_success "UDP Kernel Optimization"

# -------------------------------
# 5. Xác nhận screen & SteamCMD env
# -------------------------------
LOG "Kiểm tra screen..."
screen --version >/dev/null 2>&1
check_success "Screen ready"

LOG "Kiểm tra thư mục home..."
mkdir -p /home/hunter
check_success "Home directory check"

LOG "=============================="
LOG " TẤT CẢ DEPENDENCY ĐÃ SẴN SÀNG "
LOG " Server READY cho bước tiếp!   "
LOG "=============================="

exit 0
EOF

chmod +x ~/setup_dst_dependencies.sh
echo -e "\033[1;32m[INFO]\033[0m File setup_dst_dependencies.sh đã được tạo và cấp quyền chạy!"
