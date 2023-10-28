{ cfg, ... }:

{
  services.udev.extraRules = ''
    # Xbox One Controller
    KERNEL=="hidraw", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="045e" ATTRS{idProduct}=="02ea", MODE="0666"

    # PS4 Controller (https://github.com/epigramx/ds4drv-cemuhook/blob/master/udev/50-ds4drv.rules)
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:054C:05C4.*", MODE="0666"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", KERNELS=="0005:054C:09CC.*", MODE="0666"

    # ADB
    SUBSYSTEM=="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0186", MODE="0666", OWNER="infinity"

    # Thrustmaster T300RS GT 044f:b66e
    KERNEL=="hidraw*", ATTRS{idVendor}=="044f", ATTRS{idProduct}=="b660", TAG+="uaccess", TAG+="udev-acl"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="044f", ATTRS{idProduct}=="b660", TAG+="uaccess", TAG+="udev-acl"

    # Thrustmaster T500 RS Gear Shift 044f:b660
    KERNEL=="hidraw*", ATTRS{idVendor}=="044f", ATTRS{idProduct}=="b660", TAG+="uaccess", TAG+="udev-acl"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="044f", ATTRS{idProduct}=="b660", TAG+="uaccess", TAG+="udev-acl"
  '';

  boot.blacklistedKernelModules = [
    "wacom"
    "hid-uclogic"
  ];
}
