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

  desktop.printing.drivers = with pkgs; [
    hplipWithPlugin
  ];

  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [
      hplipWithPlugin
    ];
  };

  services.minecraft-bedrock-server.enable = true;
}
