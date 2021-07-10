let
  osu-nix-tarball = builtins.fetchTarball {
    url = "https://github.com/fufexan/osu.nix/archive/6fc02d0b88d29ea346bdcb91fff6601b922a10e0.tar.gz";
    sha256 = "1cfq1z6xcazg2zrkpbb3pd1awxyn0mskghjzj9vf6m23mxziv31k";
  };
  osu-nix = import (osu-nix-tarball);
  osu-stable = osu-nix.defaultPackage.x86_64-linux;
  discord-ipc-bridge = osu-nix.packages.x86_64-linux.discord-ipc-bridge;
in
{
  environment.systemPackages = [
    osu-stable
    discord-ipc-bridge
  ];
}
