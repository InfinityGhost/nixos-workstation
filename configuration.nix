{ config, pkgs, lib, ... }:

let
  listFiles = dir: lib.mapAttrsToList (name: type:
    "${dir}/${name}"
  ) (builtins.readDir dir);
in
{
  imports = lib.lists.flatten [
    ./hardware-configuration.nix
    ./kernel.nix
    ./users.nix
    ./udev.nix
    ./network.nix
    ./storage.nix
    ./desktop.nix
    ./pipewire.nix
    ./work.nix
    ./printing.nix
    ./libvirt.nix
    ./containers.nix
    (listFiles ./packages)
    (listFiles ./modules)
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define your hostname.
  networking.hostName = "infinity-nixos";

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable sound.
  sound.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    wget
    git
    manix
    htop
    zip
    unzip
    pciutils
    usbutils
    mkpasswd
    direnv
  ];

  # Automatically update packages
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

  # Enable remote builds
  nix = {
    distributedBuilds = true;
    trustedUsers = [
      "infinity"
      "@root"
    ];
  };

  # GNU nano settings
  programs.nano.nanorc = ''
    set suspend
    set autoindent
    set tabstospaces
    set tabsize 2
  '';

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
