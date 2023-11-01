{ lib, config, pkgs, flake, system, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.desktop.gnome;
in
{
  options.desktop.gnome = {
    enable = mkEnableOption "GNOME desktop environment";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;

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
      gnome-shell-extensions
    ];

    environment.systemPackages = with flake.nixpkgsFor.${system}; [
      # GNOME Software
      gnome.gnome-tweaks
      # GNOME Extensions
      ddterm-padded
      focus-window
      gnomeExtensions.pop-shell
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.vertical-workspaces
      # GTK+ Theme
      mint-y-icons
      # Internet
      unstable.firefox-beta
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
      unstable.libreoffice-fresh
      thunderbird
      # Virtualization
      virt-manager
      # Streaming
      obs-studio
      # Modeling
      blender
      # Utilities
      xclip
      unstable.scrcpy
    ];

    hardware.opengl.driSupport32Bit = true;

    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
      package = pkgs.unstable.opentabletdriver;
    };

    home-manager.sharedModules = [{
      dconf.settings."org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "ddterm@amezin.github.com"
          "pop-shell@system76.com"
          "trayIconsReloaded@selfmade.pl"
          "vertical-workspaces@G-dH.github.com"
          "focus-window@chris.al"
        ];
      };

      dconf.settings."org/gnome/mutter".center-new-windows = true;

      dconf.settings."org/gnome/shell/extensions/vertical-workspaces" = {
        ws-thumbnails-position = 4; # hidden thumbnails, vertical orientation
        center-search = true; # center search view

        # dash
        dash-position = 3; # move to left
        dash-show-recent-files-icon = 0; # hide show recent files icon in tray
        dash-show-windows-icon = 0; # hide show windows icon in tray

        # app grid
        center-app-grid = true; # center app list to middle of display
        app-grid-page-width-scale = 100; # width of grid
      };
    }];

    environment.etc."X11/xorg.conf.d/50-mouse-acceleration.conf".text = ''
      Section "InputClass"
        Identifier "Mouse"
        Driver "libinput"
        MatchIsPointer "yes"
        Option "AccelProfile" "flat"
        Option "AccelSpeed" "0"
      EndSection
    '';
  };
}
