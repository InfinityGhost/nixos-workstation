{ pkgs, lib, config, nixosConfig, ... }:

{
  programs.steam = {
    immutable = true;
    libraryFolders = {
      Root = {
        path = "${config.home.homeDirectory}/.local/share/Steam";
      };
      Linux = {
        path = "/mnt/Games/SteamLibraryLinux";
      };
      Windows = {
        path = "/mnt/Games/SteamLibrary";
      };
    };
  };
}
