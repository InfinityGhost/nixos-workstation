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

  services.printing = {
    enable = true;
    browsing = true;
    drivers = with pkgs; [
      hplip
    ];
  };

  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [
      hplipWithPlugin
    ];
  };

  systemd.services.terraria.wantedBy = lib.mkForce [];
  services.terraria = {
    enable = true;
    openFirewall = true;
    worldPath = "/var/lib/terraria/world.wld";
    messageOfTheDay = "Welcome to hell, enjoy your stay.";
  };
}
