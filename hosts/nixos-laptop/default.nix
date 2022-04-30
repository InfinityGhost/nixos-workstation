{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  environment.systemPackages = with pkgs; [
    mc
    brightnessctl
  ];

  networking = {
    firewall.enable = false;
    wireless = {
      userControlled = {
        enable = true;
        group = "users";
      };
      allowAuxiliaryImperativeNetworks = true;
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.remote-build.enable = true;
}