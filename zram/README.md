# zRam optimization
A small service for setting up zswap variables

## Tuned
```
dnf install -y tuned
systemctl enable --now tuned

curl -O https://raw.githubusercontent.com/Momi-V/Notizen/main/zram/tuned.conf
mkdir /etc/tuned/zswap
mv tuned.conf /etc/tuned/zswap
cat /etc/tuned/zswap/tuned.conf

:> /etc/systemd/zram-generator.conf
tuned-adm profile zswap
```

## Systemd 
```
mkdir /opt/zswap && cd /opt/zswap

curl -O https://raw.githubusercontent.com/Momi-V/Notizen/main/zram/zswap.bash
chmod +x zswap.bash

curl -O https://raw.githubusercontent.com/Momi-V/Notizen/main/zram/zswap.service
systemctl enable --now /opt/zswap/zswap.service
```
