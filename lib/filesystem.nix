{ lib, ... }:

rec {
  # Returns all subdirectories in a given directory
  listDirs = dir: map (n: ./${n}) (lib.attrNames (lib.filterAttrs (path: type: type == "directory") (builtins.readDir dir)));

  # Imports all subdirectories in a given directory into a module.
  importSubdirs = dir: { imports = listDirs dir; };

  # Filesystem mount helpers
  mount = {
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
  };
}
