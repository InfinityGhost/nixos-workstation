{ pkgs, config, ... }:

let
  steam = config.programs.steam.package;
in
{
  users.users.htpc = {
    isNormalUser = true;
    password = "";
  };

  home-manager.users.htpc = {
    home.file.".config/autostart/steam.desktop" = {
      source = "${steam}/share/applications/steam.desktop";
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
