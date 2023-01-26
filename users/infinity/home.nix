{ pkgs, lib, config, nixosConfig, ... }:

{
  programs.steam = {
    immutable = true;
    libraryFolders = {
      Root = {
        path = "${config.home.homeDirectory}/.local/share/Steam";
      };
      Linux = {
        path = "/mnt/Games/SteamLibrary";
      };
      Windows = {
        path = "/mnt/Games/Windows/SteamLibrary";
      };
    };
  };

  programs.direnv.enable = true;
}
