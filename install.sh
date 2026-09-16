#!/usr/bin/env bash
set -e

INSTALL_DIR="$HOME/.local/share/selene"
BIN_DIR="$HOME/.local/bin"

echo -e "\033[1;35m"
echo "  ___ ___| | ___ _ __   ___ "
echo " / __|/ _ \ |/ _ \ '_ \ / _ \\"
echo " \__ \  __/ |  __/ | | |  __/"
echo " |___/\___|_|\___|_| |_|\___|"
echo "       selene :3 installer   "
echo -e "\033[0m"

echo "[*] Preparing installation..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR/dump"
mkdir -p "$INSTALL_DIR/configs"
mkdir -p "$INSTALL_DIR/scripts"
mkdir -p "$BIN_DIR"

if [ -f "./selene" ]; then
    cp ./selene "$INSTALL_DIR/selene"
else
    echo "[*] Downloading selene..."
    curl -fSL "https://raw.githubusercontent.com/Selene-External/Selene/main/selene" -o "$INSTALL_DIR/selene" 2>/dev/null || {
        echo "[-] Failed to download selene."
    }
fi

chmod +x "$INSTALL_DIR/selene" 2>/dev/null || true

cat << 'EOF' > "$BIN_DIR/selene"
#!/usr/bin/env bash
INSTALL_DIR="$HOME/.local/share/selene"

PTRACE_SCOPE=$(cat /proc/sys/kernel/yama/ptrace_scope 2>/dev/null || echo "0")
HAS_CAP=$(getcap "$INSTALL_DIR/selene" 2>/dev/null | grep -q "cap_sys_ptrace" && echo "1" || echo "0")

if [ "$PTRACE_SCOPE" != "0" ] && [ "$HAS_CAP" != "1" ]; then
    echo -e "\033[1;33m[!] ptrace_scope is active ($PTRACE_SCOPE).\033[0m"
    echo -e "[*] Setting ptrace capability..."
    sudo setcap cap_sys_ptrace=eip "$INSTALL_DIR/selene" 2>/dev/null || echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope >/dev/null 2>&1 || true
fi

cd "$INSTALL_DIR"
exec "$INSTALL_DIR/selene" "$@"
EOF

chmod +x "$BIN_DIR/selene"

echo ""
echo -e "\033[1;32m[+] Selene installed successfully in $INSTALL_DIR!\033[0m"
echo -e "[*] To start in any terminal: \033[1;36mselene\033[0m"
echo -e "[*] In-game, press \033[1;35mInsert\033[0m to open menu."
