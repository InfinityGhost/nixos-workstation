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
              <connector>DP-0</connector>
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

  environment.etc."X11/xorg.conf.d/50-mouse-acceleration.conf".text = ''
    Section "InputClass"
      Identifier "Mouse"
      Driver "libinput"
      MatchIsPointer "yes"
      Option "AccelProfile" "flat"
      Option "AccelSpeed" "0"
    EndSection
  '';
}
