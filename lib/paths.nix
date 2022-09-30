{ self, lib, ... }:

with builtins;
with lib;
rec {
  dotFilesDir = toString ../.;
  modulesDir  = "${dotFilesDir}/modules";
  binDir      = "${dotFilesDir}/bin";
}
