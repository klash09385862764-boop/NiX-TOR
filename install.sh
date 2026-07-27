#!/bin/bash

set -e

CYAN='\e[1;36m'
GREEN='\e[1;32m'
RED='\e[1;31m'
NC='\e[0m'

REPO_RAW="https://raw.githubusercontent.com/1NoJoom/T.Sin/main"
INSTALL_PATH="/usr/local/bin/T.Sin"
TMP_PATH="/tmp/T.Sin.py"

if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}[-] Please run as root (sudo).${NC}"
    exit 1
fi

echo -e "${CYAN}[*] Installing T.Sin (open source)...${NC}"

if command -v apt-get >/dev/null 2>&1; then
    apt-get update -y >/dev/null 2>&1 || true
    apt-get install -y python3 python3-pip curl tor tor-geoipdb >/dev/null 2>&1 || true
fi

pip3 install --break-system-packages 'requests[socks]' >/dev/null 2>&1 || \
pip3 install 'requests[socks]' >/dev/null 2>&1 || true

if ! curl -fsSL "${REPO_RAW}/T.Sin.py?v=$(date +%s)" -o "${TMP_PATH}"; then
    curl -fsSL "${REPO_RAW}/T.sin.py?v=$(date +%s)" -o "${TMP_PATH}"
fi

if [ ! -s "${TMP_PATH}" ]; then
    echo -e "${RED}[-] Download failed. Upload T.Sin.py (or T.sin.py) to GitHub main branch.${NC}"
    exit 1
fi

if ! head -n 1 "${TMP_PATH}" | grep -q "python"; then
    printf '%s\n%s\n' '#!/usr/bin/env python3' "$(cat "${TMP_PATH}")" > "${TMP_PATH}.tmp"
    mv "${TMP_PATH}.tmp" "${TMP_PATH}"
fi

mv "${TMP_PATH}" "${INSTALL_PATH}"
chmod +x "${INSTALL_PATH}"

echo -e "${GREEN}[+] Installed to ${INSTALL_PATH}${NC}"
echo -e "${GREEN}[+] Launching T.Sin...${NC}"
echo

exec "${INSTALL_PATH}" </dev/tty
