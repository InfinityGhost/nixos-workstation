{ lib, ... }:

{
  boot.kernelPatches = [
    {
      name = "acso";
      patch = builtins.fetchurl "https://aur.archlinux.org/cgit/aur.git/plain/add-acs-overrides.patch?h=linux-vfio";
    }
  ];

  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
    "pcie_acs_override=downstream,multifunction"
  ];
}
