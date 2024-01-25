{ lib, ... }:

let
  inherit (builtins) readDir readFile;
  inherit (lib) mapAttrsToList;
in {
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
      "systemd-journal"
    ];
    openssh.authorizedKeys.keyFiles = mapAttrsToList (n: _: ./ssh/${n}) (readDir ./ssh);
  };

  home-manager.users.infinity = import ./home.nix;
}
