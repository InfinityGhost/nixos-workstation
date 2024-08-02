{ lib, pkgs, ... }:

{
  users.users.guest = {
    isNormalUser = true;
    password = "";
    shell = lib.mkForce pkgs.shadow; # disable terminal
  };

  home-manager.users.guest = {
    dconf.settings."org/gnome/shell" = {
      favorite-apps = map (n: "${n}.desktop") [
        "firefox"
        "nemo"
        "writer"
      ];
      enabled-extensions = [
        "pop-shell@system76.com"
        "trayIconsReloaded@selfmade.pl"
      ];
      disabled-extensions = [
        "ddterm@amezin.github.com"
        "vertical-workspaces@G-dH.github.com"
        "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
      ];
    };
  };
}
