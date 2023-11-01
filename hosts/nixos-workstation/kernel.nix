{ pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.unstable.zfs.latestCompatibleLinuxPackages;
    extraModprobeConfig = ''
      options kvm ignore_msrs=Y
      options kvm report_ignored_msrs=N
    '';
    kernelParams = [
      "nohibernate"
      "amd_iommu=on"
      "iommu=pt"
      "pcie_acs_override=downstream,multifunction"
      "zfs.zfs_arc_max=17179869184" # 16 GiB
    ];
  };
}
