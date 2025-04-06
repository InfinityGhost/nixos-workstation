{ lib, pkgs, ... }:

{
  systemd.services.plex.wantedBy = lib.mkForce [];
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  services.containers = {
    ubuntu.enable = true;
    fedora.enable = true;
  };

  services.printing.enableHP = true;
  services.minecraft-bedrock-server.enable = true;
}
