{ pkgs, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./udev.nix
    ./session.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  desktop.gnome.enable = true;
  desktop.games.enable = true;
}
