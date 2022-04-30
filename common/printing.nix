{ pkgs, cfg, ... }:

{
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
