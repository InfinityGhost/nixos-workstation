{ flake ? builtins.getFlake "path:${toString ./.}"
, system ? "x86_64-linux"
, pkgs ? flake.nixpkgsFor.${system}
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    nixFlakes
    nix-zsh-completions
    nix-prefetch
    nixpkgs-fmt
    nettools
    git
    gnupg
    jq
    android-tools
    dconf2nix
  ];
  shellHook = ''
    export PATH="${./bin}:$PATH"
    export PROJECT_ROOT="$(git rev-parse --show-toplevel)"
    export NIXOS_FLAKE="$PROJECT_ROOT#$(hostname)-$system"
  '';
}
