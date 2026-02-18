# LAINERS ULPGC eduroam fixer for Linux

This repo contains a small **bash** helper script to fix eduroam on Linux at ULPGC after running the official eduroam CAT installer.  
It simply adjusts the NetworkManager 802.1X settings for the existing `eduroam` connection so that the correct CA certificate and domain are used.

> Fi profile, change your username, or touch other connections.

---

## Requirements

- Linux distribution using NetworkManager (Ubuntu, Fedora, etc.).  
- `nmcli` available (part of NetworkManager).  
- You must have already:
 - Downloaded the ULPGC eduroam installer from the eduroam CAT website.  
 - Run the installer once under the same user that will run this script (so `~/.config/cat_installer/ca.pem` exists).  
- `sudo` access (the script calls `nmcli connection modify` with `sudo`).

---

## Step 1 Fi list.

---

## Step 2 Run the fixer

Run the script from the same user that ran the CAT installer:

```bash
./eduroam-fixer.sh
```

What will happen:

- If no `eduroam` connection exists, the script stops and tells you to run the CAT installer first.  
- If `~/.config/cat_installer/ca.pem` is missing, it stops and tells you to re Connect to eduroam

On campus, you can either use your desktop environment's Wirun the official ULPGC installer and ensure you see `eduroam` when you run `nmcli connection show`.  

### "Error: ~/.config/cat_installer/ca.pem not found."

- The CAT installer was not run for this user or failed to write the CA file.  
- Solution: Run the CAT installer again and verify the file exists with `ls ~/.config/cat_installer`.  

### Still cannot connect

- Doublerun this script.  
- Check NetworkManager logs for more details:

```bash
journalctl -u NetworkManager
```

---

## Security and privacy notes

- The script only adjusts settings for the existing `eduroam` connection and does not send your credentials anywhere.  
- If you choose to store your password using `nmcli` with `password-flags 0`, it will be saved in NetworkManager's system keyring; anyone with root access can potentially read it.  
- Always download the official ULPGC installer only from the eduroam CAT or official ULPGC IT pages.
- This script requires `sudo` to modify NetworkManager connections. Review the script before running it if you have security concerns.

---

## Contributing

Found a bug or have a suggestion? Feel free to open an issue or submit a pull request!

---

## License

This project is provided as-is under the MIT License. See LICENSE file for details.

---

## Acknowledgments

- Thanks to the eduroam CAT team for providing the official installers.
- Thanks to ULPGC IT services for maintaining the eduroam infrastructure.

---

**Repo:** https://github.com/Lainer2/ULPGC-EDUROAM-FIX-For-Linux-
