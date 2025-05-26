self: super: {
  looking-glass-client = super.looking-glass-client.overrideAttrs (old: rec {
    version = builtins.substring 0 7 src.rev;
    patches = [];
    postInstall = "";

    src = super.fetchFromGitHub {
      owner = "gnif";
      repo = "LookingGlass";
      rev = "f15d72cdfef744399cb46b95c21846ac00e0285a";
      hash = "sha256-UDSRL33nae5F/d2Bfoo52EytyiuWkwutXkSQD3n86/g=";
      fetchSubmodules = true;
    };
  });
}
