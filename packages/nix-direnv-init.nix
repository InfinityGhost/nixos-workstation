{ pkgs, ... }:

let
  nix-direnv-init = pkgs.writers.writeBashBin "nix-direnv-init" ''
    # TODO: fail if either exists

    cat > shell.nix <<EOF
    { pkgs ? import <nixpkgs> { } }:

    pkgs.mkShell {
      nativeBuildInputs = with pkgs; [ ];
      buildInputs = with pkgs; [ ];
      inputsFrom = with pkgs; [ ];
      hardeningDisable = [ "all" ];
    }
    EOF

    cat > .envrc <<EOF
    use nix
    EOF

    direnv allow
  '';
in
{
  environment.systemPackages = [
    nix-direnv-init
  ];
}