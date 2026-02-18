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
