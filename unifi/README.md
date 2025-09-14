# Unifi
Persistent systemd service for enabeling NPTv6 or NAT66 to give ULA VLANs internet access

## NAT66 (Simple, works with /64 prefix, no incoming connections possible)
### Install (on device)
```
curl -o /etc/systemd/system/NAT66.service https://raw.githubusercontent.com/Momi-V/Notizen/main/unifi/NAT66.service
systemctl enable --now NAT66
```

### Install (ssh)
```
ssh root@unifi "curl -o /etc/systemd/system/NAT66.service https://raw.githubusercontent.com/Momi-V/Notizen/main/unifi/NAT66.service && systemctl enable --now NAT66"
```


## NPTv6 (more complex, needs a /60 or /56, external access via local firewall rules)
### Install (on device)
```
curl -o /etc/systemd/system/update-npt6.bash    https://raw.githubusercontent.com/Momi-V/Notizen/refs/heads/main/unifi/update-npt6.bash
curl -o /etc/systemd/system/update-npt6.service https://raw.githubusercontent.com/Momi-V/Notizen/refs/heads/main/unifi/update-npt6.service
curl -o /etc/systemd/system/update-npt6.timer   https://raw.githubusercontent.com/Momi-V/Notizen/refs/heads/main/unifi/update-npt6.timer
systemctl daemon-reload
systemctl enable --now update-npt6.timer
```

### Install (ssh)
```
ssh root@unifi "curl -o /etc/systemd/system/update-npt6.bash    https://raw.githubusercontent.com/Momi-V/Notizen/refs/heads/main/unifi/update-npt6.bash; \
curl -o /etc/systemd/system/update-npt6.service https://raw.githubusercontent.com/Momi-V/Notizen/refs/heads/main/unifi/update-npt6.service; \
curl -o /etc/systemd/system/update-npt6.timer   https://raw.githubusercontent.com/Momi-V/Notizen/refs/heads/main/unifi/update-npt6.timer; \
systemctl daemon-reload; \
systemctl enable --now update-npt6.timer"
```
