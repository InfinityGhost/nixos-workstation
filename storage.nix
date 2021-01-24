{
  fileSystems."/mnt/Archive" = {
    device = "/dev/disk/by-label/Archive";
    options = [
      "nofail"
      "rw"
      "uid=1000"
      "gid=1000"
      "umask=022"
    ];
  };

  fileSystems."/mnt/HDD" = {
    device = "/dev/disk/by-label/HDD";
    options = [
      "nofail"
      "rw"
      "uid=1000"
      "gid=1000"
      "umask=022"
    ];
  };

  fileSystems."/mnt/VM" = {
    device = "/dev/sdc1";
    options = [
      "nofail"
      "rw"
      "uid=1000"
      "gid=1000"
      "umask=022"
    ];
  };

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
