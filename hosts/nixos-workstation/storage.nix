{ lib, ... }:

with lib.my.mount;

{
  fileSystems = {
    "/mnt/Archive" = ntfs "/dev/disk/by-label/Archive";
    "/mnt/HDD" = ntfs "/dev/disk/by-label/HDD";
    "/mnt/VM" = ntfs "/dev/disk/by-partuuid/ebf49ab0-01";
    "/mnt/Games" = ntfs "/dev/zvol/nixpool/games-part2";
  };
}
