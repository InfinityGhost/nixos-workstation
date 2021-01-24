{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    
    # GNOME Display Manager
    displayManager.gdm.enable = true;

    # GNOME 3 Desktop Environment
    desktopManager.gnome3 = {
      enable = true;
    };
  };

  environment.gnome3.excludePackages = with pkgs; [
    gnome3.cheese
    gnome3.geary
    gnome3.nautilus
    gnome3.totem
    gnome3.evince
  ];

  environment.systemPackages = with pkgs; [
    # GNOME stuff
    gnome3.gnome-tweaks
    # Theme
    cinnamon.mint-y-icons
    # Internet
    firefox
    discord
    # File Management
    cinnamon.nemo
    # Audio
    spotify
    # IDE
    vscode
    # Games
    steam
    lutris
    # Virtualization
    virt-manager
    virt-viewer
    # Streaming
    obs-studio
  ];

  fonts.fonts = with pkgs; [
    terminus_font_ttf
    terminus_font
  ];

  hardware.opengl.driSupport32Bit = true;
}
