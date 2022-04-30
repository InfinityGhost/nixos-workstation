{ pkgs, inputs, ... }:

{
  imports = [
    ./packages.nix
    ./games.nix
  ];

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];

    # GNOME Display Manager
    displayManager.gdm = {
      enable = true;
      wayland = false;
      nvidiaWayland = false;
    };

    # GNOME Desktop Environment
    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages = with pkgs.gnome; [
    cheese
    geary
    nautilus
    totem
    epiphany
    eog
  ];

  environment.systemPackages = with pkgs; [
    # GNOME Software
    gnome.gnome-tweaks
    gnomeExtensions.vertical-overview
    gnomeExtensions.pop-shell
    ddterm-padded
    toggle-gnome-extension
    # GTK+ Theme
    mint-y-icons
  ];

  hardware.opengl.driSupport32Bit = true;

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
}
