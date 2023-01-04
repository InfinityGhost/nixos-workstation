{ inputs, ... }:

{
  imports = [
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

  desktop.gnome.enable = true;
  desktop.games.enable = true;
  development.dotnet.enable = true;
  servers.plex.enable = true;

  services.containers = {
    ubuntu.enable = true;
    fedora.enable = true;
  };
}
