let
  mount = { device, fsType ? "auto" }: {
    inherit device fsType;
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
  };
}
