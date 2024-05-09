{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./fingerprint.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  desktop.gnome.enable = true;
  desktop.games.enable = true;

  environment.systemPackages = with pkgs; [
    vscode
  ];
}
