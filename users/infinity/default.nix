{ lib, pkgs, config, home-manager, ... }:

with lib.my;

{
  users.users.infinity = {
    isNormalUser = true;
    uid = 1000;
    hashedPassword = "$6$tHKIF.z6$YxikRiScslszerVWhawoFQZW86yFPXjHsurip3hwbldoFQ.y79.onzEd73Dr7zYn0W9mehi6bXfGz6Z3QQlHC0";
    extraGroups = [
      "wheel"
      "libvirtd"
      "networkmanager"
      "users"
      "deluge"
      "media"
    ];
    openssh.authorizedKeys.keys = map builtins.readFile (listFiles ./ssh);
  };

  users.groups.media = {};

  home-manager.users.infinity = import ./home.nix;
}
