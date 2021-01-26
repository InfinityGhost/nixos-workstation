{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./kernel.nix
    ./users.nix
    ./udev.nix
    ./network.nix
    ./storage.nix
    ./desktop.nix
    ./libvirt.nix
    ./packages/nix-direnv-init.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "infinity-nixos"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    wget
    git
    htop
    zip
    unzip
    pciutils
    usbutils
    mkpasswd
    direnv
  ];

  # Enable remote builds
  nix = {
    distributedBuilds = true;
    trustedUsers = [
      "infinity"
      "@root"
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  
  system.stateVersion = "20.09";
}

