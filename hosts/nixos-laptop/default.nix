{ pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
#    ./fingerprint.nix # TODO: fprintd thinkpad package broken
    ./guest.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  desktop.gnome = {
    enable = true;
    autoSuspend = true;
  };

  services.printing.enableHP = true;
  services.remote-build.enable = true;

  environment.systemPackages = with pkgs; [
    tigervnc
  ];

  home-manager.sharedModules = [{
    dconf.settings."org/gnome/desktop/background" = let
      uri = lib.mkForce "/home/infinity/Pictures/bg.jpg";
    in {
      picture-uri = uri;
      picture-uri-dark = uri;
    };
  }];
}
