{ lib, ... }:

let
  inherit (lib.my.filesystem) zfs vfat ntfs;
in {
  fileSystems = {
    "/" = zfs "nixpool/root";
    "/boot" = vfat "/dev/disk/by-uuid/7561-A493";
    "/nix" = zfs "nixpool/nix";
    "/home" = zfs "nixpool/home";
    "/repos" = zfs "nixpool/repos";
    "/mnt/Games" = zfs "nixpool/games";
    "/mnt/Games/Windows" = ntfs "/dev/zvol/nixpool/games/win-part2";
    "/mnt/Archive" = ntfs "/dev/disk/by-label/Archive";
    "/mnt/HDD" = ntfs "/dev/disk/by-label/HDD";
    "/mnt/VM" = ntfs "/dev/disk/by-partuuid/ebf49ab0-01";
  };
}
