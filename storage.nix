{
  boot.supportedFilesystems = [
    "ext4"
    "ntfs"
  ];

  fileSystems."/mnt/Archive" = {
    device = "/dev/disk/by-label/Archive";
    options = [
      "nofail"
      "rw"
      "uid=1000"
      "gid=100"
    ];
  };

  fileSystems."/mnt/HDD" = {
    device = "/dev/disk/by-label/HDD";
    options = [
      "nofail"
      "rw"
      "uid=1000"
      "gid=100"
    ];
  };

  fileSystems."/mnt/VM" = {
    device = "/dev/disk/by-partuuid/ebf49ab0-01";
    options = [
      "nofail"
      "rw"
      "uid=1000"
      "gid=100"
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
