{ pkgs, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_5_4;
    kernelPatches = [
      {
        name = "acso";
        patch = builtins.fetchurl "https://aur.archlinux.org/cgit/aur.git/plain/add-acs-overrides.patch?h=linux-vfio";
      }
    ];
    extraModprobeConfig = ''
      options kvm ignore_msrs=Y 
      options kvm report_ignored_msrs=N
    '';
    kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
      "pcie_acs_override=downstream,multifunction"
    ];
  };
}
