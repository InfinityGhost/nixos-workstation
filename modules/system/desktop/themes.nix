{ lib, pkgs, config, ... }:

let
  inherit (lib) mkIf mkOption types;

  cfg = config.desktop.theme;

  gtkName = if cfg.gtkName != null then cfg.gtkName else cfg.name;
  qtName = if cfg.qtName != null then cfg.qtName else gtkName; # fallback to GTK
in
{
  options.desktop.theme = {
    name = mkOption {
      description = "The name of the theme";
      type = with types; nullOr str;
      default = null;
    };

    gtkPackage = mkOption {
      description = "The GTK theme package";
      type = with types; nullOr package;
      default = null;
    };

    gtkName = mkOption {
      description = "The name of the GTK theme";
      type = with types; nullOr str;
      default = null;
    };

    qtPackage = mkOption {
      description = "The Qt theme package";
      type = with types; nullOr package;
      default = null;
    };

    qtName = mkOption {
      description = "The name of the Qt theme";
      type = with types; nullOr str;
      default = null;
    };
  };

  config = mkIf (cfg.name != null) {
    home-manager.sharedModules = [{
      dconf.settings."org/gnome/desktop/interface" = {
        gtk-theme = gtkName;
      };

      gtk = {
        enable = cfg.gtkPackage != null;
        theme = {
          name = gtkName;
          package = cfg.gtkPackage;
        };
      };

      qt = {
        enable = cfg.qtPackage != null;
        platformTheme.name = qtName;
        style = {
          name = qtName;
          package = cfg.qtPackage;
        };
      };
    }];
  };
}
