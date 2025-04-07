# Pangolin quickinstall

## NixOS LiveBoot
```
curl -L https://github.com/nix-community/nixos-images/releases/latest/download/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz | tar -xzf- -C /root
/root/kexec/run
```

## Install NixOS
```
curl -O https://raw.githubusercontent.com/HPPinata/Notizen/refs/heads/main/pangolin/setup.bash
bash setup.bash
```

## Setup Pangolin with autoupdate on reboot
```
wget https://raw.githubusercontent.com/HPPinata/Notizen/refs/heads/main/pangolin/install.bash
bash install.bash
```
