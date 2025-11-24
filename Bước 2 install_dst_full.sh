cat > ~/install_dst_full.sh << 'EOF'
#!/bin/bash
set -euo pipefail

# ==============================
# DST Dedicated Server Installer
# ADVANCED VERSION
# ==============================

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
NC="\e[0m"

ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
fail()  { echo -e "${RED}[FAILED]${NC} $1"; exit 1; }
info()  { echo -e "${YELLOW}[INFO]${NC} $1"; }

check() {
    if [ $? -ne 0 ]; then
        fail "$1"
    else
        ok "$1"
    fi
}

# ==============================
# STEP 0 — ENV CHECK
# ==============================
if [ "$EUID" -eq 0 ]; then
    fail "KHÔNG chạy script bằng root! Hãy chạy bằng user thường (hunter) + sudo trong các bước cần."
fi

info "Bắt đầu cài đặt DST Dedicated Server…"

STEAM_DIR="$HOME/steamcmd"
DST_DIR="$HOME/dstserver"
KLEI_DIR="$HOME/.klei/DoNotStarveTogether/MyDediServer"

# ==============================
# STEP 1 — INSTALL STEAMCMD
# ==============================
info "[1] Installing SteamCMD…"

mkdir -p "$STEAM_DIR"
check "Tạo thư mục $STEAM_DIR"

cd "$STEAM_DIR"

# Link ổn định của SteamCMD (đúng chuẩn)
wget -q --show-progress https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -O steamcmd_linux.tar.gz
check "Tải SteamCMD"

tar -xzf steamcmd_linux.tar.gz
check "Giải nén SteamCMD"

[ -f "$STEAM_DIR/steamcmd.sh" ] || fail "Thiếu steamcmd.sh!"

ok "SteamCMD đã sẵn sàng"


# ==============================
# STEP 2 — INSTALL DST SERVER
# ==============================
info "[2] Installing DST Dedicated Server từ SteamCMD…"

mkdir -p "$DST_DIR"
check "Tạo folder dstserver"

cd "$STEAM_DIR"

# FIX quan trọng — force_install_dir phải đặt trước login
./steamcmd.sh +force_install_dir "$DST_DIR" +login anonymous +app_update 343050 validate +quit
check "Cài đặt DST Dedicated Server"

# Validate folder structure
[ -d "$DST_DIR/bin" ]  || fail "Thiếu DST bin!"
[ -d "$DST_DIR/bin64" ] || fail "Thiếu DST bin64!"
[ -d "$DST_DIR/mods" ]  || fail "Thiếu DST mods!"

ok "DST server đã cài xong"


# ==============================
# STEP 3 — CREATE SHARD STRUCTURE
# ==============================
info "[3] Tạo cấu trúc Klei (Master + Caves)…"

mkdir -p "$KLEI_DIR/Master"
mkdir -p "$KLEI_DIR/Caves"

[ -d "$KLEI_DIR/Master" ] || fail "Không tạo được folder Master!"
[ -d "$KLEI_DIR/Caves" ]  || fail "Không tạo được folder Caves!"

ok "Cấu trúc MyDediServer được tạo thành công"


# ==============================
# STEP 4 — FIX PERMISSIONS (QUAN TRỌNG)
# ==============================
info "[4] Kiểm tra & sửa quyền folder…"

chmod -R 755 "$STEAM_DIR"
chmod -R 755 "$DST_DIR"
chmod -R 755 "$KLEI_DIR"

ok "Đã sửa quyền thư mục"


# ==============================
# DONE
# ==============================
echo -e "${GREEN}"
echo "===================================="
echo "  DST SERVER INSTALLATION COMPLETED "
echo "===================================="
echo -e "${NC}"

exit 0
EOF

chmod +x ~/install_dst_full.sh
echo -e "\e[32m[INFO]\e[0m File install_dst_full.sh đã được tạo và cấp quyền chạy!"






~/install_dst_full.sh
