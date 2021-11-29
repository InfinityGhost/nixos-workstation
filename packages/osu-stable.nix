{ pkgs, lib, ... }:

let
  nix-gaming-tarball = pkgs.fetchFromGitHub {
    owner = "fufexan";
    repo = "nix-gaming";
    rev = "caf86b1dd4b4cdd59970590eaaa9c009c9f1e6ea";
    sha256 = "sha256-ZkUW8JfjDmFZnRQKeBKQvqlWLRgIq4p6v2QfLrjSm0s=";
  };
  nix-gaming = import (nix-gaming-tarball);
in
{
  environment.systemPackages = with nix-gaming.packages.x86_64-linux; [
    osu-stable
    winestreamproxy
  ];
}
