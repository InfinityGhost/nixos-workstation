{ config, pkgs, lib, ... }:

{
  imports = lib.lists.flatten [
    ./hardware-configuration.nix
    ./nix.nix
    ./kernel.nix
    ./users.nix
    ./udev.nix
    ./network.nix
    ./storage.nix
    ./packages.nix
    ./terminal.nix
    ./nano.nix
    ./desktop.nix
    ./pipewire.nix
    ./printing.nix
    ./libvirt.nix
    ./containers.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  system.stateVersion = "20.09";
}
