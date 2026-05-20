self: super: {
  looking-glass-client = super.looking-glass-client.overrideAttrs (old: rec {
    version = builtins.substring 0 7 src.rev;
    patches = [];
    postInstall = "";

    src = super.fetchFromGitHub {
      owner = "gnif";
      repo = "LookingGlass";
      rev = "7f31ecf5e572ecdfa64306be76e49ee537f5fdbf";
      hash = "sha256-l4TtW1g1bxCCEmgxBDikysV2c3NoXSBGV7FiWMz3ojg=";
      fetchSubmodules = true;
    };
  });
}
