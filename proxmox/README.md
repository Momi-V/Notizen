# Proxmox
Useful scriptlets for various Proxmox tweaks

## All scripts
```
mkdir setup && cd setup
list=( block btrfs cron dhcp font hosts ksm repo nosub pcie )
for i in ${list[@]}; do
  wget https://raw.githubusercontent.com/HPPinata/Notizen/prox-v6/proxmox/scripts/$i.bash
  chmod +x $i.bash
  cat $i.bash
  bash $i.bash
done
cd ..
reboot
```
