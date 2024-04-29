{ pkgs, config, ... }:

let
  inherit (pkgs) makeDesktopItem;

  steam = config.programs.steam.package;
in
{
  users.users.htpc = {
    isNormalUser = true;
    password = "";
  };

  home-manager.users.htpc = {
    home.file.".config/autostart/steam.desktop" = {
      force = true;
      source = "${steam}/share/applications/steam.desktop";
    };

    home.file.".config/pop-shell/config.json" = {
      force = true;
      text = builtins.toJSON {
        float = [
          { class = "streaming_client"; }
          { class = "steam"; title = "Steam Big Picture Mode"; }
        ];
      };
    };

    dconf.settings."org/gnome/shell" = {
      favorite-apps = map (n: "${n}.desktop") [
        "firefox"
        "steam"
        "plexmediaplayer"
        "discord"
      ];
      enabled-extensions = [
        "pop-shell@system76.com"
        "trayIconsReloaded@selfmade.pl"
        "vertical-workspaces@G-dH.github.com"
        "focus-window@chris.al"
        "no-overview@fthx"
        "noannoyance@daase.net"
      ];
    };

    dconf.settings."org/gnome/desktop/screensaver".lock-enabled = false;
    dconf.settings."org/gnome/desktop/wm/preferences".auto-raise = true;

    dconf.settings."org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };

    dconf.settings."org/gnome/settings-daemon/plugins/media-keys" = {
      volume-mute = [ "<Shift><Super>m" ];
    };

    dconf.settings."org/gnome/shell/extensions/vertical-workspaces" = {
      app-grid-incomplete-pages = false;
    };
  };

  services.xserver.displayManager.gdm.settings.daemon = {
    TimedLoginEnable = true;
    TimedLogin = "htpc";
    TimedLoginDelay = 5;
  };

  environment.systemPackages = with pkgs; [
    tigervnc
    gnomeExtensions.no-overview
    noannoyance
  ];
}
