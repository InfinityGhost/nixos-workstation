{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    
    # GNOME Display Manager
    displayManager.gdm.enable = true;

    # GNOME 3 Desktop Environment
    desktopManager.gnome3.enable = true;
  };

  environment.gnome3.excludePackages = with pkgs; [
    gnome3.cheese
    gnome3.geary
    gnome3.nautilus
    gnome3.totem
    gnome3.epiphany
    gnome3.eog
    gnome3.gnome-remote-desktop
  ];

  environment.systemPackages = with pkgs; [
    # GNOME stuff
    gnome3.gnome-tweaks
    # Theme
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
    steam
    lutris
    # Virtualization
    virt-manager
    virt-viewer
    # Streaming
    obs-studio
    # Utilities
    xclip
  ];

  fonts.fonts = with pkgs; [
    terminus_font_ttf
    terminus_font
  ];

  hardware.opengl.driSupport32Bit = true;
}
