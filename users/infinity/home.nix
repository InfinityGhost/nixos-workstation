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

  dconf.settings."org/gnome/desktop/background" = {
    picture-uri = "file:///${pkgs.gnome.gnome-backgrounds}/share/backgrounds/gnome/pixels-l.webp";
    picture-uri-dark = "file:///${pkgs.gnome.gnome-backgrounds}/share/backgrounds/gnome/pixels-d.webp";
  };
}
