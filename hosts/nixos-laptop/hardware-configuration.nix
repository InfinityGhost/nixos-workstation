{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    kernelModules = [ ];
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [ "uhci_hcd" "ehci_pci" "ata_piix" "firewire_ohci" "tifm_7xx1" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
      kernelModules = [ ];
    };
    supportedFilesystems = [ "ext4" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/81ecd829-34e3-40ca-95fb-d4a92b3d46d5";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/4322-C151";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/3564eddf-7c74-4e78-a3fc-c44cf4ac01b5";
    }
  ];

  networking = {
    useDHCP = lib.mkDefault false;
    interfaces.enp3s8.useDHCP = lib.mkDefault true;
    interfaces.wlp2s0.useDHCP = lib.mkDefault true;
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = true;
}
