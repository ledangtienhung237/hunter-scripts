cat > ~/setup_dst_dependencies.sh << 'EOF'
#!/bin/bash

# ===============================
# DST SERVER — DEPENDENCY SETUP
# ===============================
LOG() {
    echo -e "\033[1;32m[INFO]\033[0m $1"
}
ERROR() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}

check_step() {
    if [ $? -ne 0 ]; then
        ERROR "$1 FAILED! Dừng script ngay."
        exit 1
    else
        LOG "$1 thành công."
    fi
}

LOG "BẮT ĐẦU CẬP NHẬT HỆ THỐNG..."

# Update package lists
sudo apt update -y
check_step "apt update"

# Upgrade hệ thống
sudo apt upgrade -y
check_step "apt upgrade"

# Add i386 architecture
LOG "Bật kiến trúc 32-bit..."
sudo dpkg --add-architecture i386
check_step "dpkg add-architecture i386"

# Update lại sau khi thêm kiến trúc
sudo apt update -y
check_step "apt update lần 2"

# Install required packages
LOG "Cài đặt dependency cho SteamCMD + DST..."
sudo apt install -y lib32gcc-s1 screen wget tar ca-certificates
check_step "Cài lib32gcc-s1, screen, wget, tar, ca-certificates"

LOG "============================"
LOG "TẤT CẢ ĐÃ HOÀN TẤT THÀNH CÔNG!"
LOG "Server ready để bước tiếp theo."
LOG "============================"

EOF




🔧 Cấp quyền chạy script
chmod +x ~/setup_dst_dependencies.sh
