#!/usr/bin/env bash
set -e

echo "== LAINER'S eduroam Linux fixer =="

if ! nmcli -t -f NAME connection show | grep -qx "eduroam"; then
    echo "Error: No 'eduroam' connection found in NetworkManager."
    echo "Run the official ULPGC eduroam CAT installer first, then re-run this script."
    exit 1
fi

CA_PATH="$HOME/.config/cat_installer/ca.pem"
if [ ! -f "$CA_PATH" ]; then
    echo "Error: $CA_PATH not found."
    echo "Make sure you have run the ULPGC eduroam CAT installer on this user account."
    exit 1
fi

echo "Found eduroam profile and CA certificate."

echo "Applying NetworkManager 802.1X settings for ULPGC eduroam..."

sudo nmcli connection modify eduroam \
    802-1x.ca-cert "$CA_PATH" \
    802-1x.altsubject-matches "" \
    802-1x.domain-suffix-match "ulpgc.es"

echo
echo "Done. Current relevant settings:"
nmcli connection show eduroam | grep -iE 'ca-cert|altsubject|domain-suffix' || true

echo
echo "Optional: to store your eduroam password, run:"
echo '  sudo nmcli connection modify eduroam 802-1x.password "YOUR_PASSWORD" 802-1x.password-flags 0'
echo
echo "To connect now (on campus), run:"
echo "  nmcli --ask connection up eduroam"
