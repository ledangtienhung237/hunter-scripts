cat > ~/install_dst_full.sh << 'EOF'
#!/bin/bash
set -euo pipefail

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
NC="\e[0m"

ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
fail()  { echo -e "${RED}[FAILED]${NC} $1"; exit 1; }
info()  { echo -e "${YELLOW}[INFO]${NC} $1"; }

if [ "$EUID" -eq 0 ]; then
    fail "Không chạy script bằng root!"
fi

STEAM_DIR="$HOME/steamcmd"
DST_DIR="$HOME/dstserver"
KLEI_DIR="$HOME/.klei/DoNotStarveTogether/MyDediServer"

info "[1] Installing SteamCMD"

mkdir -p "$STEAM_DIR"
cd "$STEAM_DIR"

wget -q --show-progress https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz -O steamcmd_linux.tar.gz
tar -xzf steamcmd_linux.tar.gz
[ -f "$STEAM_DIR/steamcmd.sh" ] || fail "Thiếu steamcmd.sh"

ok "SteamCMD OK"

info "[2] Installing DST Dedicated Server"

mkdir -p "$DST_DIR"
cd "$STEAM_DIR"

./steamcmd.sh +force_install_dir "$DST_DIR" +login anonymous +app_update 343050 validate +quit

[ -d "$DST_DIR/bin" ]  || fail "Thiếu DST bin"
[ -d "$DST_DIR/bin64" ] || fail "Thiếu DST bin64"

ok "DST Server OK"

info "[3] Create Master & Caves structure"

mkdir -p "$KLEI_DIR/Master"
mkdir -p "$KLEI_DIR/Caves"

chmod -R 755 "$STEAM_DIR" "$DST_DIR" "$KLEI_DIR"

echo -e "${GREEN}DST INSTALL COMPLETE${NC}"
EOF


chmod +x ~/install_dst_full.sh
~/install_dst_full.sh
