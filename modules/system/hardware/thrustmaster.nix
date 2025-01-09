{ lib, pkgs, config, ... }:

let
  inherit (lib) mkIf mkEnableOption readFile;
  inherit (pkgs) fetchFromGitHub;

  cfg = config.hardware.thrustmaster;

  hid-tmff2 = config.boot.kernelPackages.hid-tmff2;

  hid-tmff2-git = fetchFromGitHub {
    owner = "Kimplul";
    repo = "hid-tmff2";
    rev = "master";
    hash = "sha256-bFhclVZfMDrLYTSMAoALe+WIhLfi/sv7FgL1rTTVPRA=";
  };
in
{
  options.hardware.thrustmaster = {
    enable = mkEnableOption "Thrustmaster FFB Racing Wheel";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      oversteer # UI configuration app for FFB
    ];

    boot = {
      blacklistedKernelModules = [ "hid-thrustmaster" ];

      extraModulePackages = [
        hid-tmff2
      ];

      kernelModules = [
        "hid-tmff2"
      ];
    };

#    services.udev.extraRules = readFile "${hid-tmff2-git}/udev/99-thrustmaster.rules";
  };
}
