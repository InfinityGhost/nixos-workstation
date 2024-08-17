{ pkgs, ... }:

{
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  desktop.vm = {
    machines = {
      win-vfio.desktopName = "Windows";
    };
    shares = {
      vm = "/mnt/Archive/VM";
      repos = "/repos";
    };
  };

  services.single-gpu-passthrough = {
    enable = true;
    pciDevices = {
      "0000:2d:00.0" = "nvidia";        # GPU
      "0000:2d:00.1" = "snd_hda_intel"; # GPU Audio
      "0000:2f:00.4" = "snd_hda_intel"; # Onboard Audio Controller
      "0000:2a:00.1" = "xhci_hcd";      # xHCI Controller
      "0000:2a:00.3" = "xhci_hcd";      # xHCI Controller
    };
    extraModules = [
      "nvidiafb"
    ];
    mountpoints = [
      "/dev/zvol/nixpool/games-part2"
    ];
  };

  networking.interfaces.br0.useDHCP = true;
  networking.bridges.br0 = {
    interfaces = [ "enp39s0" ];
  };

#  services.dnsmasq = {
#    enable = true;
#    extraConfig = ''
#      listen-address=127.0.0.1
#
#      bind-interfaces
#    '';
#  };
}
