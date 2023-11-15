{ config, lib, pkgs, modulesPath, ... }:

let
  inherit (lib) mkDefault;
  inherit (lib.my.filesystem) ext4 vfat;
in {
  hardware.enableRedistributableFirmware = mkDefault true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems = {
    "/" = ext4 "/dev/disk/by-label/nixos-htpc";
    "/home" = ext4 "/dev/disk/by-label/nixos-htpc-home";
    "/boot" = vfat "/dev/disk/by-uuid/13E2-94BF";
  };

  swapDevices = map (device: { inherit device; }) [
    "/dev/disk/by-uuid/4992dd74-d41f-40be-bab3-f01fa8157ee3"
  ];

  networking.useDHCP = mkDefault true;

  hardware.cpu.intel.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;

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
              <connector>HDMI-1</connector>
              <vendor>GSM</vendor>
              <product>LG TV SSCR2</product>
              <serial>0x01010101</serial>
            </monitorspec>
            <mode>
              <width>1920</width>
              <height>1080</height>
              <rate>60.000</rate>
            </mode>
          </monitor>
        </logicalmonitor>
      </configuration>
    </monitors>
  '';
}
