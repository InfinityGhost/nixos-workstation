{
  fileSystems."/server" = {
    device = "192.168.0.3:/export/media";
    fsType = "nfs";
    options = [
      "nofail"
      "x-systemd.automount"
      "noauto"
    ];
  };
}
