{ inputs, ... }:

{
  imports = [
    ./containers.nix
    ./hardware-configuration.nix
    ./kernel.nix
    ./libvirt.nix
    ./network.nix
    ./pipewire.nix
    ./storage.nix
    ./udev.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}