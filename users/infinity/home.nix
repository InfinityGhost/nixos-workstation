{ pkgs, lib, config, nixosConfig, ... }:

{
  programs.direnv.enable = true;

  dconf.settings."org/gnome/shell".favorite-apps = map (n: n + ".desktop") [
    "firefox"
    "nemo"
    "discord"
    "thunderbird"
    "org.gnome.Console"
    "code"
    "rider"
    "steam"
  ];

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
    icon-them = "Mint-Y-Dark-Blue";
    monospace-font-name = "Ubuntu Mono 12";
    color-scheme = "prefer-dark";
    show-battery-percentage = true;
  };

  dconf.settings."org/gnome/desktop/background" = let
    name = "lcd-rainbow";
    uri = theme: "file:///${pkgs.gnome-backgrounds}/share/backgrounds/gnome/${name}-${theme}.jxl";
  in {
    picture-uri = uri "l";
    picture-uri-dark = uri "d";
  };
}
