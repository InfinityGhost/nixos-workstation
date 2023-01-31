{ pkgs, lib, config, nixosConfig, ... }:

{
  programs.steam.libraryFolders = {
    root = "${config.home.homeDirectory}/.local/share/Steam";
    linux = "/mnt/Games/SteamLibrary";
    windows = "/mnt/Games/Windows/SteamLibrary";
  };

  programs.direnv.enable = true;
}
