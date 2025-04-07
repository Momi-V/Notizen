cat <<'EOL' | sfdisk /dev/vda
size=3M type=21686148-6449-6E6F-744E-656564454649
size=509M
size=40G
type=swap
EOL

mkfs.fat -F 32 /dev/vda2
fatlabel /dev/vda2 NIXBOOT
mkfs.btrfs /dev/vda3 -L NIXROOT
mkswap /dev/vda4
swapon /dev/vda4

mount /dev/disk/by-label/NIXROOT /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/NIXBOOT /mnt/boot

nixos-generate-config --root /mnt
wget -O /mnt/etc/nixos/configuration.nix https://raw.githubusercontent.com/HPPinata/Notizen/refs/heads/main/pangolin/configuration.nix
cd /mnt
nixos-install
