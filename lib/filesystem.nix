{ lib, ... }:

rec {
  # Returns all subdirectories in a given directory
  listDirs = dir: map (n: ./${n}) (lib.attrNames (lib.filterAttrs (path: type: type == "directory") (builtins.readDir dir)));

  # Imports all subdirectories in a given directory into a module.
  importSubdirs = dir: { imports = listDirs dir; };
}
