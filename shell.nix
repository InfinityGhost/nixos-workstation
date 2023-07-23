{ pkgs ? import <nixpkgs> {}, ... }:

with pkgs;

let
  nixBin = writeShellScriptBin "nix" ''
    ${nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
  '';
in mkShell {
  buildInputs = [
    nix
    nix-zsh-completions
    git
    gnupg
    jq
  ];
  shellHook = ''
    export PATH="${./bin}:${nixBin}/bin:$PATH"
  '';
}
