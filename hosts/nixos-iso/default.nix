{ config, pkgs, inputs, ... }:

{
  imports = with inputs; [
    "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    "${nixos}/nixos/modules/installer/cd-dvd/channel.nix"
  ];

  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  networking.wireless.enable = false;

  services.remote-build.enable = true;

  environment.etc."flake".source = toString ../..;

  desktop.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    vscode.fhs
  ];
}
