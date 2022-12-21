{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    git
    manix
    htop
    btop
    zip
    unzip
    pciutils
    usbutils
    mkpasswd
  ];
}
