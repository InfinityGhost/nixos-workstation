{ pkgs, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    extraModprobeConfig = ''
      options kvm ignore_msrs=Y
      options kvm report_ignored_msrs=N
    '';
    kernelParams = [
      "nohibernate"
      "amd_iommu=on"
      "iommu=pt"
      "pcie_acs_override=downstream,multifunction"
      "zfs.zfs_arc_max=3758096384"
    ];
  };
}