@echo off
REM /*
REM     Generiert ein neues WPA-Kennwort und traegt dieses in die LANCOM WLC-Konfiguration
REM     ein. Generiert dann einen passenden WiFi QR-Code dazu.
REM     
REM     20230615 b.stromberg@data-systems.de
REM */

REM --- WLC Zugang und Profilname (SSH)
set wlcadresse=wlc-address
set wlcuser=<USERNAME>
set wlcpass=<PASSWORD>
set wlcprofile=<PROFILNAME>
set wlcssid=<SSID>

REM --- Das Kennwort Pre- und Suffix haben.
REM     Wenn nicht gewollt, leerlassen, keine Leerzeichen.
set prefix=prefix
set suffix=suffix

REM --- HTML-Settings
REM     htmlpfad= Pfad an den der QR-Code und das HTML nach der generierung verschoben werden.
set htmltitle=<TITEL DER SEITE>
set htmlpfad=<PFAD>

REM ------------------------------------------------------------------------

REM --- Mein Run-Verzeichnis soll auch mein Kontext sein
pushd "%~dp0"

REM --- Kennwort generieren
REM     Batch-Random-Zahlen von 1 bis 32767
REM     sieht so aus: prefix9883suffix
set newpass=%prefix%%random%%suffix%

REM --- Kennwort (NUR das Kennwort) via SSH ins WLC-Profil schreiben
echo y | plink -ssh %wlcuser%@%wlcadresse% -pw %wlcpass% "exit"
plink %wlcuser%@%wlcadresse% -batch -pw %wlcpass% "cd /Setup/WLAN-Management/AP-Configuration/Networkprofiles ; set  "%wlcprofile%" {Parent-Name} * {Local-Values} * {SSID} * {Operating} * {VLAN-Mode} * {VLAN-Id} * {Encryption} * {WPA1-Session-Keytypes} * {WPA2-3-Session-Keytypes} * {WPA-Version} * {Key} "%newpass%" {Radio-Band} * {Continuation-Time} * {Min-Tx-Rate} * {Max-Tx-Rate} * {Basic-Rate} * {11b-Preamble} * {MAC-Filter} * {Cl.-Brg.-Support} * {Max-Stations} * {SSID-Broadcast} * {Min-HT-MCS} * {Max-HT-MCS} * {Short-Guard-Interval} * {Max-Spatial-Streams} * {Send-Aggregates} * {RADIUS-Accounting} * {Connect-SSID-to} * {Inter-Station-Traffic} * {RADIUS-Profile} * {STBC-activated} * {LDPC-activated} * {Min-Client-Strength} * {Min-Client-Disassoc-Strength} * {IEEE802.11u-Network-Profile} * {OKC} * {WPA2-Key-Management} * {APSD} * {Prot.-Mgmt-Frames} * {Tx-Limit} * {Rx-Limit} * {Per-Client-Tx-Limit} * {Per-Client-Rx-Limit} * {LBS-Tracking} * {LBS-Tracking-List} * {11ac-Beamforming} * {Convert-to-Unicast} * {Transmit-only-Unicasts} *  {Continuation-Time-use-default} * {WPA-802.1X-Security-Level} * {Timeframe} * ; exit"

REM --- QR-Code bauen
REM     -l {LMQH}    error correction level from L (lowest) to H (highest).
REM     -s {3-99}    dots size (pixels)
REM     -t {PNG,EPS,SVG,ANSI,ANSI256,ASCII,ASCIIi,UTF8,ANSIUTF8}
if exist wifi_login.png del /f /q wifi_login.png
qrencode "WIFI:T:WPA;S:%wlcssid%;P:%newpass%;;" -t PNG -l M -o wifi_login.png -s 10

REM --- Eine "druckbare" HTLM Seite bauen
echo ^<html^>^<style^>body {font-family: arial, helv;background: url^(logo.png^) no-repeat;background-size: 226px;background-position: 65px 25px;}^</style^> >wifi_login.html
echo ^<head^>^<title^>%htmltitle%%^</title^>^</head^>^<br /^>^<br /^>^<h1 style="text-align: center"^>WLAN Internet-Zugang^</h1^> >>wifi_login.html
echo ^<br style="clear: both" /^>^<p style="text-align:center;"^>^<img src="wifi_login.png" /^>^<br /^>^<br /^>^<b^>%wlcssid%^</b^>^<br /^>%newpass%^</p^>^</html^> >>wifi_login.html

REM --- QR und HTML an den Zielort verschieben
move /y wifi_login.png %htmlpfad%
move /y wifi_login.html %htmlpfad%

REM --- Micrologging (nur lastlog)
echo %date% %time% %0 %newpass% > %~n0.log
