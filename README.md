## User guide: eduroam on Linux at ULPGC

This guide explains how to fix and connect to **eduroam** on Linux at ULPGC using `nmcli` and the official eduroam CAT profile.

> ⚠️ This guide assumes you are using NetworkManager (most mainstream desktop distros do: Ubuntu, Fedora, etc.).

---

### 1. Run the official ULPGC eduroam installer (once)

1. Go to the eduroam CAT website and download the **Linux** installer for **ULPGC**.
2. You will get a file similar to: `eduroam-linux-UdLPdGC.py`.
3. Make it executable and run it:

```bash
cd ~/Downloads
chmod +x eduroam-linux-*.py
./eduroam-linux-*.py

