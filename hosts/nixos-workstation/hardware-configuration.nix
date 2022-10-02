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

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    video.hidpi.enable = lib.mkDefault true;
  };
}
