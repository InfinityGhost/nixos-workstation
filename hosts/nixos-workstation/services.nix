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
}
