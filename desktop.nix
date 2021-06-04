{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];

    # GNOME Display Manager
    displayManager.gdm.enable = true;

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
    gnome-remote-desktop
  ];

  environment.systemPackages = with pkgs; [
    # GNOME Software
    gnome.gnome-tweaks
    gnomeExtensions.vertical-overview
    # GTK+ Theme
    cinnamon.mint-y-icons
    # Internet
    firefox
    google-chrome
    discord
    transmission-gtk
    # File Management
    cinnamon.nemo
    # Audio
    spotify
    # Photos
    gthumb
    gimp
    # Video
    vlc
    # Office
    libreoffice
    thunderbird
    # IDE
    vscode
    # Games
    mesa
    lutris
    # Virtualization
    virt-manager
    virt-viewer
    # Streaming
    obs-studio
    # Utilities
    xclip
  ];

  programs.steam.enable = true;

  fonts.fonts = with pkgs; [
    terminus_font_ttf
    terminus_font
  ];

  hardware.opengl.driSupport32Bit = true;
}
