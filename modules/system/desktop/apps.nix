{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.desktop.packages;

  common = with pkgs; [
    firefox
    google-chrome
    discord
    gnome-feeds
    cinnamon.nemo
  ];

  entertainment = with pkgs; [
    # Audio
    spot
    # Photos
    gthumb
    # Video
    vlc
    flowblade
    plex-media-player
    # Streaming
  ];

  office = with pkgs; [
    libreoffice
    thunderbird
  ];

  creative = with pkgs; [
    # Photos/Art
    gimp
    krita
    # Video
    obs-studio
  ];

  virtualization = [ pkgs.virt-manager ];

  games = {
    program.steam.enable = true;

    environment.systemPackages = with pkgs; with pkgs.user; [
      # Games
      mesa
      lutris
      heroic
      nix-gaming.osu-lazer-bin
      nix-gaming.osu-stable
      minecraft
      minecraft-bedrock
      dolphinEmu
      cemu
      gnome.aisleriot
      gnome.quadrapassel
      # Proton dependencies
      python3
    ];
  };

  dotnet = with pkgs.unstable.dotnetCorePackages; combinePackages [ sdk_6_0 sdk_7_0 ];

  development = with pkgs; [
    # SDK
    dotnet
    # IDE
    vscode
    unstable.jetbrains.rider
  ];

  misc = with pkgs; [
    uget
    xclip
    scrcpy
    user.android-screen
    blender
  ];

  systemPackages = pkgs: { environment.systemPackages = pkgs; };

  configs = {
    inherit common entertainment office games development misc;
  };

in
{
  options.desktop.apps = {
    common = mkEnableOption "Common desktop packages";
    entertainment = mkEnableOption "Audio/Visual entertainment";
    office = mkEnableOption "Office applications";
    creative = mkEnableOption "Creative applications";
    games = mkEnableOption "Games";
    virtualization = mkEnableOption "Virtualization tools";
    development = mkEnableOption "Development packages";
    misc = mkEnableOption "Miscellaneous utilities";
  };

  config = lib.my.combineAttrs (attrValues (filterAttrs (n: v: hasAttr n cfg && cfg.${n}) configs));
}
