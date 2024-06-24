{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./fingerprint.nix
    ./printing.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  desktop.gnome.enable = true;
  desktop.games.enable = true;

  services.remote-build.enable = true;

  environment.systemPackages = with pkgs; [
    vscode
    tigervnc
  ];
}
