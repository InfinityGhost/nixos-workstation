{ lib, ... }:

rec {
  # Returns all subitems in a given directory that match a predicate.
  listSubpaths = dir: predicate: map (n: "${dir}/${n}") (lib.attrNames (lib.filterAttrs predicate (builtins.readDir dir)));

  # Returns all files in a given directory.
  listFiles = dir: listSubpaths dir (path: type: type == "regular");

  # Returns all subdirectories in a given directory.
  listDirs = dir: listSubpaths dir (path: type: type == "directory");

  # Imports all subdirectories in a given directory into a module.
  importSubdirs = dir: { imports = listDirs dir; };

  # Filesystem mount helpers
  mount = {
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
  };
}
