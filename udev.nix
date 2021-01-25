{ cfg, ... }:

{
  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput"
    # Wacom CTL-470
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="056a", ATTRS{idProduct}=="00dd", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="056a", ATTRS{idProduct}=="00dd", MODE="0666"
    # Wacom CTL-480
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="056a", ATTRS{idProduct}=="030e", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="056a", ATTRS{idProduct}=="030e", MODE="0666"
  '';

  boot.blacklistedKernelModules = [
    "wacom"
    "hid-uclogic"
  ];
} 