{ pkgs, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_5_14;
    kernelPatches = [
      {
        name = "acso";
        patch = builtins.fetchurl {
          url = "https://aur.archlinux.org/cgit/aur.git/plain/add-acs-overrides.patch?h=linux-vfio";
          sha256 = "0xrzb1klz64dnrkjdvifvi0a4xccd87h1486spvn3gjjjsvyf2xr";
        };
      }
    ];
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
