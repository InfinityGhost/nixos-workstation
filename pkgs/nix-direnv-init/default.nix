{ lib
, writers
, symlinkJoin
}:

let
  pname = "nix-direnv-init";
  bin = writers.writeBashBin pname ''
    function check-file
    {
      if [ -e "$1" ]; then
        echo "Aborting: The file '$1' already exists."
        exit 1;
      fi
    }
    check-file "shell.nix"
    check-file ".envrc"

    echo "Creating nix direnv files..."

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
in symlinkJoin {
  name = pname;
  paths = [ bin ];
}