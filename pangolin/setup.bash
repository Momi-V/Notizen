echo "Wiping Drives"
swapoff -a
umount /dev/vda*
wipefs -a /dev/vda*
sleep 1

echo "Creating Partitions"
cat <<'EOL' | sfdisk /dev/vda
label: gpt
size=3M type=21686148-6449-6E6F-744E-656564454649
size=509M
size=40G
type=swap
EOL
sleep 1

echo "Formatting Filesystems"
mkfs.fat -F 32 -n NIXBOOT /dev/vda2
mkfs.btrfs /dev/vda3 -L NIXROOT
mkswap /dev/vda4
sleep 1

echo "Mounting Filesystems"
swapon /dev/vda4
mount /dev/disk/by-label/NIXROOT /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/NIXBOOT /mnt/boot
sleep 1

echo "Generating and Fetching config"
nixos-generate-config --root /mnt
curl -o /mnt/etc/nixos/configuration.nix https://raw.githubusercontent.com/HPPinata/Notizen/refs/heads/main/pangolin/configuration.nix
sleep 1

echo "Installing NixOS"
cd /mnt
nix-channel --update
nixos-install
sleep 1

echo "Copying root SSH keys"
cp -r /root/.ssh/ /mnt/root/
sleep 1
