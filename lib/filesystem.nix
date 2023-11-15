{ ... }: {
  # Filesystem mount helpers
  vfat = device: {
    inherit device;
    fsType = "vfat";
  };

  ext4 = device: {
    inherit device;
    fsType = "ext4";
  };

  zfs = device: {
    inherit device;
    fsType = "zfs";
  };

  ntfs = device: {
    inherit device;
    fsType = "ntfs3";
    options = [
      "nofail"
      "rw"
      "user"
      "exec"
      "force"
      "x-systemd.automount"
      "uid=1000"
      "gid=100"
    ];
  };

  nfs = device: {
    inherit device;
    fsType = "nfs";
    options = [
      "nofail"
      "user"
      "x-systemd.automount"
    ];
  };

  # Flake paths
  flakeDir = ../.;
  binDir = ../bin;
}
