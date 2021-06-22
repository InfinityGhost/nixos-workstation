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
  ];

  nixpkgs.overlays = [
    (self: super: rec {
      mint-y-icons = super.cinnamon.mint-y-icons.overrideAttrs (old: {
        src = super.fetchFromGitHub {
          owner = "linuxmint";
          repo = "mint-y-icons";
          rev = "29eb94bc16a8b77423cfaca60a84fc18c931f1b6";
          sha256 = "1jvz435jdy0x6kq1n9cxalhw88r7gg2sxlz78cghdm7cq8msvxi2";
        };
      });
    })
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
    scrcpy
  ];

  programs.steam.enable = true;

  fonts.fonts = with pkgs; [
    terminus_font_ttf
    terminus_font
  ];

  hardware.opengl.driSupport32Bit = true;
}
