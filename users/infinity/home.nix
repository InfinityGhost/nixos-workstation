{ pkgs, lib, config, nixosConfig, ... }:

{
  programs.steam.libraryFolders = {
    root = "${config.home.homeDirectory}/.local/share/Steam";
    linux = "/mnt/Games/SteamLibrary";
    windows = "/mnt/Games/Windows/SteamLibrary";
  };

  programs.direnv.enable = true;

  dconf.settings."org/gnome/shell".favorite-apps = map (n: n + ".desktop") [
    "firefox"
    "nemo"
    "discord"
    "thunderbird"
    "code"
    "rider"
  ];

  dconf.settings."org/gnome/desktop/wm/keybindings" = {
    move-to-center = [ "<Super>D" ];
    panel-run-dialog = [ "<Super>r" ];
    switch-windows = [ "<Alt>Tab" ];
    switch-windows-backward = [ "<Shift><Alt>Tab" ];
    toggle-fullscreen = [ "<Shift><Super>Return" ];
    toggle-maximized = [ "<Super>f" ];
    # fix conflicts with defaults
    switch-applications-backward = [];
    switch-applications = [];
    maximize = [];
    unmaximize = [];
  };

  dconf.settings."org/gnome/mutter".edge-tiling = false;

  dconf.settings."org/gnome/shell/extensions/pop-shell" = {
    tile-by-default = true;
    show-title = true;
    fullscreen-launcher = true; # allow launcher over fullscreen window
    gap-inner = 3;
    gap-outer = 3;
    mouse-cursor-focus-location = 4; # center
  };

  dconf.settings."org/gnome/desktop/interface" = {
    gtk-theme = "Adwaita-dark";
    icon-them = "Mint-Y-Dark-Blue";
    monospace-font-name = "Ubuntu Mono 12";
    color-scheme = "prefer-dark";
    show-battery-percentage = true;
  };

  dconf.settings."org/gnome/desktop/background" = {
    picture-uri = "file:///${pkgs.gnome.gnome-backgrounds}/share/backgrounds/gnome/pixels-l.webp";
    picture-uri-dark = "file:///${pkgs.gnome.gnome-backgrounds}/share/backgrounds/gnome/pixels-d.webp";
  };
}
