{ pkgs ? import <nixpkgs> {}, ... }:
  
pkgs.mkShell {
  buildInputs = with pkgs; [
    nixFlakes
    nix-zsh-completions
    git
    gnupg
    jq
  ];
  shellHook = ''
    export PATH="${./bin}:$PATH"
    export PROJECT_ROOT="$(git rev-parse --show-toplevel)"

    cdr() {
      [ -d "$PROJECT_ROOT" ] && cd "$PROJECT_ROOT"
    }
  '';
}
