{ pkgs, inputs, ... }:

{
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; with inputs.fufexan.packages.x86_64-linux; [
    # Games
    mesa
    lutris
    heroic
    osu-lazer-bin
    osu-stable
    minecraft
    minecraft-bedrock
    dolphinEmu
    cemu
    gnome.aisleriot
    gnome.quadrapassel
    # Steam dependencies
    python3
  ];
}
