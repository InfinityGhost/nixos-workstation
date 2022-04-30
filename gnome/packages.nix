{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
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
    plex-media-player
    # Office
    libreoffice
    thunderbird
    # Virtualization
    virt-manager
    # Streaming
    obs-studio
    # Modeling
    blender
    # Utilities
    xclip
    scrcpy
    android-screen
  ];
}