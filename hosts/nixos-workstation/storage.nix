{ lib, ... }:

with lib.my.mount;

{
  fileSystems = {
    "/" = zfs "nixpool/root";
    "/nix" = zfs "nixpool/nix";
    "/home" = zfs "nixpool/home";
    "/repos" = zfs "nixpool/repos";
    "/boot" = {
      device = "/dev/disk/by-uuid/7561-A493";
      fsType = "vfat";
    };
    "/mnt/Archive" = ntfs "/dev/disk/by-label/Archive";
    "/mnt/HDD" = ntfs "/dev/disk/by-label/HDD";
    "/mnt/VM" = ntfs "/dev/disk/by-partuuid/ebf49ab0-01";
    "/mnt/Games" = ntfs "/dev/zvol/nixpool/games-part2";
  };
}
