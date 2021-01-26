{ pkgs, ... }:

let
  win10 = pkgs.writers.writeBashBin "win10" ''
    virsh --connect qemu:///system start win10
  '';
in
{
  environment.systemPackages = [
    win10
  ];
}
