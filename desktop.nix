{ pkgs, inputs, ... }:

{
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
    # GTK+ Theme
    mint-y-icons
    # Internet
    firefox
    google-chrome
    discord
    transmission-gtk
    gnome-feeds
    # File Management
    cinnamon.nemo
    uget
    # Audio
    spotify
    # Photos
    gthumb
    gimp
    krita
    # Video
    vlc
    flowblade
    # Office
    libreoffice
    thunderbird
    # IDE
    vscode
    jetbrains.rider
    # Games
    mesa
    lutris
    osu-lazer
    inputs.fufexan.packages.x86_64-linux.osu-stable
    minecraft
    minecraft-bedrock
    dolphinEmu
    cemu
    gnome.aisleriot
    gnome.quadrapassel
    # Virtualization
    virt-manager
    virt-viewer
    # Streaming
    obs-studio
    # Utilities
    xclip
    scrcpy
    android-screen
    # Steam Dependencies
    python3
  ];

  programs.steam.enable = true;

  fonts.fonts = with pkgs; [
    terminus_font_ttf
    terminus_font
  ];

  hardware.opengl.driSupport32Bit = true;
}
