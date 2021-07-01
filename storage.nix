let
  mount = device: {
    inherit device;
    options = [
      "nofail"
      "rw"
      "uid=1000"
      "gid=100"
    ];
  };
  mount-nfs = device: {
    inherit device;
    fsType = "nfs";
    options = [
      "nofail"
      "x-systemd.automount"
      "noauto"
    ];
  };
in
{
  boot.supportedFilesystems = [
    "ext4"
    "ntfs"
  ];

  fileSystems = {
    "/mnt/Archive" = mount "/dev/disk/by-label/Archive";
    "/mnt/HDD" = mount "/dev/disk/by-label/HDD";
    "/mnt/VM" = mount "/dev/disk/by-partuuid/ebf49ab0-01";
    "/server" = mount-nfs "192.168.0.3:/export/media";
  };
}
