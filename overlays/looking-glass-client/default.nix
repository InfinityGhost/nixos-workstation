self: super: {
  looking-glass-client = super.looking-glass-client.overrideAttrs (old: rec {
    version = builtins.substring 0 7 src.rev;
    patches = [];
    postInstall = "";

    src = super.fetchFromGitHub {
      owner = "gnif";
      repo = "LookingGlass";
      rev = "656d01a694e0a008e5e645e63fcbafde83ff5931";
      hash = "sha256-LynoV1rmbhzvFZ3cJw0Xif6WKZ9spHe15h7PioJTmyU=";
      fetchSubmodules = true;
    };
  });
}
