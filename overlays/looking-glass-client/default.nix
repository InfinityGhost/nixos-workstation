self: super: {
  looking-glass-client = super.looking-glass-client.overrideAttrs (old: rec {
    version = builtins.substring 0 7 src.rev;
    patches = [];
    postInstall = "";

    src = super.fetchFromGitHub {
      owner = "gnif";
      repo = "LookingGlass";
      rev = "cb304115f68eb5ba5632eaacf5fb2d34f93e6814";
      hash = "sha256-bK3/tBReH1TMurQsOtaIVKmTbxriSV8JfFMSwHZvDaY=";
      fetchSubmodules = true;
    };
  });
}
