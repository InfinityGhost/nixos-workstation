let
  mount = { device, fsType ? "auto" }: {
    inherit device fsType;
    options = [
      "nofail"
      "rw"
      "user"
      "exec"
      "x-systemd.automount"
      "uid=1000"
      "gid=100"
    ];
  };
  mount-nfs = { device }: {
    inherit device;
    fsType = "nfs";
    options = [
      "nofail"
      "user"
      "x-systemd.automount"
    ];
  };
in
{
  boot.supportedFilesystems = [
    "ext4"
    "ntfs"
  ];

  fileSystems = {
    "/mnt/Archive" = mount {
      device = "/dev/disk/by-label/Archive";
      fsType = "ntfs3";
    };
    "/mnt/HDD" = mount {
      device = "/dev/disk/by-label/HDD";
      fsType = "ntfs3";
    };
    "/mnt/VM" = mount {
      device = "/dev/disk/by-partuuid/ebf49ab0-01";
      fsType = "ntfs3";
    };
    "/mnt/Games" = mount {
      device = "/dev/zvol/nixpool/games-part2";
      fsType = "ntfs3";
    };
    "/mnt/server" = mount-nfs {
      device = "192.168.0.3:/export/media";
    };
  };
}
