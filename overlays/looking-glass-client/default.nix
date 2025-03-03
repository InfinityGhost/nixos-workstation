self: super: {
  looking-glass-client = super.looking-glass-client.overrideAttrs (old: rec {
    version = "B7-rc1-bleeding";
    patches = [];
    src = super.fetchFromGitHub {
      owner = "gnif";
      repo = "LookingGlass";
      rev = "e25492a3a36f7e1fde6e3c3014620525a712a64a";
      hash = "sha256-DBmCJRlB7KzbWXZqKA0X4VTpe+DhhYG5uoxsblPXVzg=";
      fetchSubmodules = true;
    };
  });
}
