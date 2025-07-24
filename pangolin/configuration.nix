# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  # Use latest Kernel and zSwap
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "zswap.enabled=1" "zswap.max_pool_percent=50" "zswap.compressor=zstd" "zswap.zpool=zsmalloc" ];

  networking.hostName = "pangolin"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  # networking.networkmanager.settings.connection.autoconnect = true; # Make sure autoconnect is active.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl wget dnsutils socat
    docker-compose
    git
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.qemuGuest.enable = true;

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    persistent = true;
    allowReboot = true;
  };

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
    persistent = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    persistent = true;
    options = "--delete-older-than 30d";
  };

  # Enable cron service
  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/1 * * * * root . /etc/profile; bash /var/pangolin/dyndns.bash"
      "@reboot root . /etc/profile; bash /var/pangolin/update.bash"
      "@reboot root . /etc/profile; socat TCP6-LISTEN:3478,fork TCP4:localhost:3478"
      "@reboot root . /etc/profile; socat UDP6-RECVFROM:3478,fork UDP4-SENDTO:localhost:3478"
      "@reboot root . /etc/profile; socat TCP6-LISTEN:28967,fork TCP4:localhost:28967"
      "@reboot root . /etc/profile; socat UDP6-RECVFROM:28967,fork UDP4-SENDTO:localhost:28967"
      "@reboot root . /etc/profile; socat TCP6-LISTEN:28968,fork TCP4:localhost:28968"
      "@reboot root . /etc/profile; socat UDP6-RECVFROM:28968,fork UDP4-SENDTO:localhost:28968"
    ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
