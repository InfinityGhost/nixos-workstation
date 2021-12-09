{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
      supportedFilesystems = [ "zfs" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    supportedFilesystems = [ "zfs" ];
    extraModulePackages = [ ];
  };

  fileSystems."/" = {
    device = "nixpool/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "nixpool/nix";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "nixpool/home";
    fsType = "zfs";
  };

  fileSystems."/repos" = {
    device = "nixpool/repos";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7561-A493";
    fsType = "vfat";
  };

  swapDevices = [ ];

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    video.hidpi.enable = lib.mkDefault true;
  };
}
