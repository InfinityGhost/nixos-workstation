{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
      supportedFilesystems = [ "zfs" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    supportedFilesystems = [ "zfs" ];
    extraModulePackages = [ ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false; # GTX 1070

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.xserver.displayManager.gdm.monitors.xml = ''
    <monitors version="2">
      <configuration>
        <logicalmonitor>
          <x>0</x>
          <y>0</y>
          <scale>1</scale>
          <primary>yes</primary>
          <monitor>
            <monitorspec>
              <connector>DP-4</connector>
              <vendor>GBT</vendor>
              <product>G34WQC</product>
              <serial>20532B000925</serial>
            </monitorspec>
            <mode>
              <width>3440</width>
              <height>1440</height>
              <rate>144.000</rate>
            </mode>
          </monitor>
        </logicalmonitor>
      </configuration>
    </monitors>
  '';
}
