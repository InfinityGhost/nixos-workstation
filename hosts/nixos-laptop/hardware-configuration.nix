{ config, lib, pkgs, modulesPath, ... }:

let
  inherit (lib.my.filesystem) ext4 vfat;
in
{
  imports = [
    "${modulesPath}/installer/scan/not-detected.nix"
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = ext4 "/dev/disk/by-uuid/2b9adeac-39c9-4221-a9d5-3ccc4ee83edd";
  fileSystems."/home" = ext4 "/dev/disk/by-uuid/1f09af93-636c-4e8d-802a-839edf809b1d";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/AE46-5E34";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/11ef5fce-27c3-42f2-bdae-70578cffa160"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
