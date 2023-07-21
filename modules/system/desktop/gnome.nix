{ lib, config, pkgs, inputs, ... }:

let
  cfg = config.desktop.gnome;
in
{
  options.desktop.gnome = with lib; {
    enable = mkEnableOption "GNOME desktop environment";
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];

      # GNOME Display Manager
      displayManager.gdm = {
        enable = true;
        wayland = false;
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
      # GTK+ Theme
      mint-y-icons
      # Internet
      unstable.firefox
      unstable.google-chrome
      unstable.discord
      gnome-feeds
      # File Management
      cinnamon.nemo
      uget
      # Audio
      spot
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
      user.android-screen
    ];

    hardware.opengl.driSupport32Bit = true;

    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };

    home-manager.sharedModules = [(
      { pkgs, ... }: {
        dconf.settings."org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = [
            "ddterm@amezin.github.com"
            "pop-shell@system76.com"
            "trayIconsReloaded@selfmade.pl"
            "vertical-overview@RensAlthuis.github.com"
          ];
        };

        home.packages = with pkgs; [
          ddterm-padded
          gnomeExtensions.pop-shell
          gnomeExtensions.tray-icons-reloaded
          vertical-overview
        ];
      }
    )];
  };
}
