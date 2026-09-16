#!/usr/bin/env bash
set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DIR"

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
