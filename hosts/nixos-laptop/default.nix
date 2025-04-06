{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./fingerprint.nix
    ./guest.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  desktop.gnome.enable = true;
  desktop.games.enable = true;

  services.printing.enableHP = true;
  services.remote-build.enable = true;

  environment.systemPackages = with pkgs; [
    tigervnc
  ];
}
