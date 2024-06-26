{ lib, config, pkgs, inputs, ... }:

let
  cfg = config.desktop.games;
in
{
  options.desktop.games = with lib; {
    enable = mkEnableOption "games";
  };

  config = lib.mkIf cfg.enable {
    programs.steam.enable = true;

    environment.systemPackages = with pkgs; with pkgs.user; [
      # GPU drivers
      mesa
      # Launchers
      lutris
      heroic
      # minecraft # marked broken nixpkgs
      minecraft-bedrock
      dolphinEmu
      cemu
      gnome.aisleriot
      gnome.quadrapassel
      # Steam dependencies
      python3
      killall
      # Proton
      winetricks
      protontricks
    ];
  };
}
