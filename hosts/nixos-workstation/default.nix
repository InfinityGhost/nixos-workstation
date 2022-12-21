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

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  desktop = {
    gnome.enable = true;
    apps = {
      common = true;
      entertainment = true;
      office = true;
      creative = true;
      games = true;
      virtualization = true;
      development = true;
      misc = true;
    };
  };

  servers.plex.enable = true;
}
