#!/usr/bin/env bash
set -e

INSTALL_DIR="$HOME/.local/share/selene"
cd "$INSTALL_DIR" || {
    echo "[!] Selene installation not found at $INSTALL_DIR. Please run the install script first."
    exit 1
}

REPO="Selene-External/Selene"
DOWNLOAD_URL="https://raw.githubusercontent.com/$REPO/main/selene"

echo "[*] Checking for Selene updates from $REPO..."
echo "[*] Downloading latest Selene binary..."

curl -fSL -o selene_update "$DOWNLOAD_URL" 2>/dev/null || {
    echo "[!] Download failed. Could not fetch the binary from GitHub."
    exit 1
}

if [ -f "selene_update" ]; then
    echo "[*] Installing update..."
    chmod +x selene_update
    mv selene_update selene
    echo "[+] Selene updated successfully!"
else
    echo "[!] Download failed."
    exit 1
fi
