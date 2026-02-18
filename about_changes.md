### Background: why eduroam is broken on Linux at ULPGC

I used the official **eduroam CAT** installer for Linux for ULPGC. It configures:

- EAP‑TTLS  
- Inner authentication (phase2) PAP  
- ULPGC CA certificate  
- Server verification parameter: `altsubject-matches=DNS:radius.ulpgc.es`

When connecting, the client (wpa_supplicant via NetworkManager) associates with the access point, but the TLS phase of the EAP authentication fails consistently. The logs (`journalctl`) show messages such as:

- `TLS: altSubjectName match 'DNS:radius.ulpgc.es' not found`  
- `CTRL-EVENT-EAP-TLS-CERT-ERROR ... err='AltSubject mismatch'`  
- `SSL_connect error: ... certificate verify failed`

In other words, the client correctly receives the RADIUS server certificate (`CN=radius.ulpgc.es`, signed by the ULPGC CA), but the `altsubject-matches` check fails because the server certificate does **not** include `DNS:radius.ulpgc.es` in the **Subject Alternative Name (SAN)** field. The certificate uses the older “CN‑only” style, while the CAT profile assumes the more modern SAN‑based verification.

As a result, any Linux user who:

- Uses the official ULPGC eduroam CAT installer, and  
- Keeps server verification with `altsubject-matches` enabled  

will hit an authentication loop: the system keeps rejecting ULPGC’s own server certificate because of this mismatch between the certificate and the generated profile.

A quick *diagnostic* workaround is to disable certificate verification entirely (removing the CA or `altsubject-matches`), which makes the connection work immediately. This confirms that the problem is not the credentials or the OS, but the certificate validation policy. However, this workaround is insecure and should **not** be recommended.

Temporary diagnostic commands:

```bash
sudo nmcli connection modify eduroam 802-1x.ca-cert "" 802-1x.altsubject-matches ""
nmcli --ask connection up eduroam
