{ pkgs, lib, ... }:

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

  networking.interfaces.br0.useDHCP = true;
  networking.bridges.br0 = {
    interfaces = [ "enp39s0" ];
  };

  services.looking-glass.enable = true;
}
