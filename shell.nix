{ flake ? builtins.getFlake "path:${toString ./.}"
, system ? "x86_64-linux"
, pkgs ? flake.nixpkgsFor.${system}
}:

let
  updateScript = pkgs.writeShellApplication {
    name = "update";
    text = ''
      echo "Updating lockfile..."
      nix flake update

      echo "Updating packages..."
      for script in ./pkgs/*/update.sh; do #*/
        echo "Executing '$script'"
        eval "$script"
      done
    '';
  };

in pkgs.mkShell {
  buildInputs = with pkgs; [
    nix-zsh-completions
    nix-prefetch
    nixpkgs-fmt
    nettools
    git
    gnupg
    jq
    android-tools
    dconf2nix
    updateScript
    shellcheck
  ];
  shellHook = ''
    export PATH="${./bin}:$PATH"
    export PROJECT_ROOT="$(git rev-parse --show-toplevel)"
    export NIXOS_FLAKE="$PROJECT_ROOT#$(hostname)-$system"
  '';
}
