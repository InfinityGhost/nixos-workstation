{ lib, ... }:

let
  inherit (lib.my.filesystem) zfs vfat ntfs;
in {
  fileSystems = {
    "/" = zfs "nixpool/root";
    "/boot" = vfat "/dev/disk/by-uuid/A27C-9FA2";
    "/nix" = zfs "nixpool/nix";
    "/home" = zfs "nixpool/home";
    "/repos" = zfs "nixpool/repos";
    "/mnt/Games" = zfs "nixpool/games";
    "/mnt/Games/Windows" = ntfs "/dev/zvol/nixpool/games/win-part1";
    "/mnt/Archive" = ntfs "/dev/disk/by-label/Archive";
    "/mnt/HDD" = ntfs "/dev/disk/by-label/HDD";
  };
}
