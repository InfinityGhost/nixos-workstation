{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.sakura;

  version = "3.8.5";
  ref = builtins.replaceStrings [ "." ] [ "_" ] "SAKURA_${version}";
in {
  options = {
    programs.sakura.config = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        Global sakura configuration to be used.
        If this is left empty, no global configuration will be used.
        See the SAKURA(1) manpage for usage.
      '';
    };
  };

  config = mkIf (cfg.config != {}) {
    nixpkgs.overlays = [
      (self: super: rec {
        sakura = super.sakura.overrideAttrs (old: {
          inherit version;
          src = super.fetchFromGitHub {
            owner = "dabisu";
            repo = "sakura";
            ref = ref;
            sha256 = "01rlsc29dmmz0ymg52rc9bbswffwiw7apn2spx2cj25g421kbaja";
          };
          patches = [ ./etc.patch ];
        });
      })
    ];

    environment.etc."sakura/sakura.conf".text = lib.generators.toINI {} cfg.config;
  };
}
