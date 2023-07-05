# Lancom WiFi Password QR-Code Generator
Ein einfaches Batch-Script, das einem Admin relativ komfortabel etwas Arbeit abnimmt:
- Generiert ein SEHR EINFACHES "random" WPA-PSK (Kennwort) aus prä- oder Suffing und einer Random-Zahl
- Aktualisiert dieses neue Kennwort via SSH in einem Lancom-WLC Profil
- Generiert den  dazu passenden "WIFI QR code" für iOS/Android
- Generiert eine "druckbare" HTML-Seite mit dem Code darauf
- Verschiebt die HTML-Seite und den Code in ein Zielverzeichnis

Das Bild lässt sich natürlich an beliebiger Stelle ablegen, zum Beispiel in einem Intranet.

Im Lieferumfang:
- Plink (https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html), GPL
- qrencode (https://fukuchi.org/works/qrencode/), GPL

## Setup
- wifi-qr.cmd bearbeiten: Config-Variablen füllen
- "logo.png" (z.B. Firmenlogo) in Ziel-Verzeichnis ablegen (für das HTML, etwa 230pc)

## ToDo
- Das PNG könnte natürlich auch ein viel cooles Site-integrierts SVG sein
- Zu Powershell übersetzen
