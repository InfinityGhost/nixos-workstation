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
      source = makeDesktopItem {
        desktopName = "Steam";
        exec = "${steam}/bin/steam -fullscreenopengl -720p";
      };
#      source = "${steam}/share/applications/steam.desktop";
    };
  };

  services.xserver.displayManager.gdm.settings.daemon = {
    AutomaticLoginEnable = true;
    AutomaticLogin = "htpc";
  };

  environment.systemPackages = with pkgs; [
    tigervnc
  ];
}
