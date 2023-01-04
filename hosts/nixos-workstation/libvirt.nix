{ pkgs, ... }:

{
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  systemd.services."libvirtd" = {
    path = with pkgs; [
      kmod
    ];
  };

  desktop.vm = {
    machines = {
      win-vfio.desktopName = "Windows";
      macos-vfio.desktopName = "macOS";
    };
    shares = {
      vm = "/mnt/Archive/VM";
    };
  };

  services.single-gpu-passthrough = {
    enable = true;
    pciDevices = {
      "0000:2d:00.0" = "nvidia";        # GPU
      "0000:2d:00.1" = "snd_hda_intel"; # GPU Audio
      "0000:2f:00.4" = "snd_hda_intel"; # Onboard Audio Controller
      "0000:2f:00.3" = "xhci_hcd";      # xHCI Controller
    };
    extraModules = [
      "nvidiafb"
    ];
    mountpoints = [
      "/dev/zvol/nixpool/games-part2"
    ];
  };
}
