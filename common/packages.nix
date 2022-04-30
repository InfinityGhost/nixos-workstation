{ pkgs, lib, ... }:

{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = lib.lists.flatten [
      (import ../overlays)
      (import ../pkgs)
    ];
  };

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
    direnv
  ];
}