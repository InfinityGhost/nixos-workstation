{ config, pkgs, inputs, ... }:

{
  imports = with inputs; [
    "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
  ];

  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];

  services.remote-build.enable = true;

  nix.package = pkgs.nixUnstable;
}