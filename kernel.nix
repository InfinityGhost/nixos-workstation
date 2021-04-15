{ pkgs, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_5_4;
    kernelPatches = [
      {
        name = "acso";
        patch = builtins.fetchurl "https://aur.archlinux.org/cgit/aur.git/plain/add-acs-overrides.patch?h=linux-vfio";
      }
      # {
      #   # https://gist.github.com/rupansh/5746cb29b6ce644a37355e4002d22714
      #   name = "rdtsc-spoof";
      #   patch = builtins.fetchurl "https://gist.github.com/rupansh/5746cb29b6ce644a37355e4002d22714/raw/efda329359905e7a0a0540b674c087d330492dd2/rdtsc-spoof.patch";
      # }
    ];
    kernelParams = [
      "intel_iommu=on"
      "iommu=pt"
      "pcie_acs_override=downstream,multifunction"
    ];
  };
}
