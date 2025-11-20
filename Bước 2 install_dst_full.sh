cat > install_dst_full.sh << 'EOF'
#!/bin/bash

GREEN="\e[32m"
RED="\e[31m"
NC="\e[0m"

check_success() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[OK]${NC} $1"
    else
        echo -e "${RED}[FAILED]${NC} $1"
        exit 1
    fi
}

check_exists() {
    if [ -e "$1" ]; then
        echo -e "${GREEN}[OK]${NC} Found: $1"
    else
        echo -e "${RED}[FAILED]${NC} Missing: $1"
        exit 1
    fi
}

echo "==============================="
echo "   INSTALL DST DEDICATED SERVER"
echo "==============================="

#######################################
# STEP 1 – Install SteamCMD
#######################################

echo "[1] Installing SteamCMD..."

mkdir -p "$HOME/steamcmd"
check_success "Created folder ~/steamcmd"

cd "$HOME/steamcmd"

wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -O steamcmd_linux.tar.gz
check_success "Downloaded SteamCMD"

tar -xvzf steamcmd_linux.tar.gz
check_success "Extracted SteamCMD"

check_exists "$HOME/steamcmd/steamcmd.sh"

#######################################
# STEP 2 – Install DST Dedicated Server
#######################################

echo "[2] Installing DST Dedicated Server..."

mkdir -p "$HOME/dstserver"
check_success "Created folder ~/dstserver"

cd "$HOME/steamcmd"

# FIX CHUẨN: force_install_dir phải đặt trước +login
./steamcmd.sh +force_install_dir "$HOME/dstserver" +login anonymous +app_update 343050 validate +quit
check_success "SteamCMD installed DST dedicated server"

check_exists "$HOME/dstserver/bin"
check_exists "$HOME/dstserver/bin64"
check_exists "$HOME/dstserver/data"
check_exists "$HOME/dstserver/mods"

#######################################
# STEP 3 – Create Klei folder structure
#######################################

echo "[3] Creating Klei server structure..."

mkdir -p "$HOME/.klei/DoNotStarveTogether/MyDediServer/Master"
check_success "Created Master shard folder"

mkdir -p "$HOME/.klei/DoNotStarveTogether/MyDediServer/Caves"
check_success "Created Caves shard folder"

check_exists "$HOME/.klei/DoNotStarveTogether/MyDediServer"

#######################################
# DONE
#######################################

echo -e "${GREEN}===================================="
echo " DST SERVER INSTALLATION COMPLETED "
echo "====================================${NC}"
EOF






✅ Sau đó cấp quyền chạy
chmod +x install_dst_full.sh
