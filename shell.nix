{ flake ? builtins.getFlake "path:${toString ./.}"
, system ? "x86_64-linux"
}:

let
  pkgs = flake.nixpkgsFor.${system};
in pkgs.mkShell {
  buildInputs = with pkgs; [
    nixFlakes
    nix-zsh-completions
    nixpkgs-fmt
    nettools
    git
    gnupg
    jq
    android-tools
  ];
  shellHook = ''
    export PATH="${./bin}:$PATH"
    export PROJECT_ROOT="$(git rev-parse --show-toplevel)"
    export NIXOS_CONFIGURATION="$(hostname)-$system"
  '';
}
