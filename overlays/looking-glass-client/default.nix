self: super: {
  looking-glass-client = super.looking-glass-client.overrideAttrs (old: rec {
    version = builtins.substring 0 7 src.rev;
    patches = [];
    postInstall = "";

    src = super.fetchFromGitHub {
      owner = "gnif";
      repo = "LookingGlass";
      rev = "3efe47ffb21ca96ed46b2a9342b3cee4df553987";
      hash = "sha256-kIS5JuEu2DnZdB+kRQ6jUR6pcR0hYiJLjZK3witvJcM=";
      fetchSubmodules = true;
    };
  });
}
