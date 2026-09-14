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

echo "[*] Preparando instalacao..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"

if [ -f "./selene" ]; then
    cp ./selene "$INSTALL_DIR/selene"
else
    echo "[*] Baixando binario compilado..."
    curl -fSL "https://raw.githubusercontent.com/yrozxm/Selene/main/selene" -o "$INSTALL_DIR/selene" 2>/dev/null || {
        echo "[-] Nao foi possivel baixar o binario remoto. Certifique-se de compilar localmente ou configurar a URL do release."
    }
fi

chmod +x "$INSTALL_DIR/selene" 2>/dev/null || true

cat << 'EOF' > "$BIN_DIR/selene"
#!/usr/bin/env bash
INSTALL_DIR="$HOME/.local/share/selene"

PTRACE_SCOPE=$(cat /proc/sys/kernel/yama/ptrace_scope 2>/dev/null || echo "0")
HAS_CAP=$(getcap "$INSTALL_DIR/selene" 2>/dev/null | grep -q "cap_sys_ptrace" && echo "1" || echo "0")

if [ "$PTRACE_SCOPE" != "0" ] && [ "$HAS_CAP" != "1" ]; then
    echo -e "\033[1;33m[!] Yama ptrace_scope está ativo ($PTRACE_SCOPE).\033[0m"
    echo -e "[*] Executando comando para liberar leitura de memoria externa..."
    sudo setcap cap_sys_ptrace=eip "$INSTALL_DIR/selene" 2>/dev/null || echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope >/dev/null 2>&1 || true
fi

cd "$INSTALL_DIR"
exec "$INSTALL_DIR/selene" "$@"
EOF

chmod +x "$BIN_DIR/selene"

echo ""
echo -e "\033[1;32m[+] Selene instalado com sucesso em $INSTALL_DIR!\033[0m"
echo -e "[*] Para iniciar em qualquer terminal: \033[1;36mselene\033[0m"
echo -e "[*] No jogo, pressione \033[1;35mInsert\033[0m para abrir o menu."
