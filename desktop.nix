{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ]; # Video Drivers
    displayManager.gdm.enable = true; # Display Manager

    # GNOME 3 Desktop Environment
    desktopManager.gnome3 = {
      enable = true;
    };
  };

  environment.gnome3.excludePackages = with pkgs; [
    gnome3.cheese
    gnome3.geary
    gnome3.nautilus
  ];

  environment.systemPackages = with pkgs; [
    # GNOME stuff
    gnome3.gnome-tweaks
    # Internet
    firefox
    discord
    # File Management
    cinnamon.nemo
    # Audio
    spotify
    # Games
    steam
    lutris
  ];

  hardware.opengl.driSupport32Bit = true;
}
