{ pkgs, ... }:

let
  win10 = pkgs.writers.writeBashBin "win10" ''
    virsh --connect qemu:///system start win10-vfio
  '';
in
{
  environment.systemPackages = [
    win10
  ];
}
