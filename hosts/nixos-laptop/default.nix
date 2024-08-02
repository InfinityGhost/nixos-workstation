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
  desktop.printing.drivers = with pkgs; [
    hplipWithPlugin
  ];

  services.remote-build.enable = true;

  environment.systemPackages = with pkgs; [
    vscode
    tigervnc
  ];
}
