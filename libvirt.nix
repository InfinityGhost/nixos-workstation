{ pkgs, ... }:

let
  createShare = path: {
    path = path;
    browseable = "yes";
    "acl allow execute always" = "true";
    "read only" = "no";
    "guest ok" = "yes";
    "create mask" = "0644";
    "directory mask" = "0755";
    "force user" = "infinity";
    "force group" = "users";
  };
in
{
  virtualisation.libvirtd = {
    enable = true;
  };

  systemd.services."libvirtd" = {
    path = with pkgs; [
      kmod
    ];
  };

  services.single-gpu-passthrough = {
    enable = true;
    machines = [
      "win10-vfio"
      "win11-vfio"
      "macos-vfio"
    ];
    pciDevices = {
      "0000:01:00.0" = "nvidia";        # GPU
      "0000:01:00.1" = "snd_hda_intel"; # GPU Audio
      "0000:00:1b.0" = "snd_hda_intel"; # Onboard Audio Controller
      "0000:00:14.0" = "xhci_hcd";      # xHCI Controller
    };
    extraModules = [
      "nvidiafb"
    ];
  };

  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = smb_host
      netbios name = smb_host
      security = user 
      hosts allow = 192.168.122.0/24 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      games = createShare "/games";
      vmshare = createShare "/server/VM";
    };
  };
}
