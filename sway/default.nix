{ config, lib, pkgs, ... }:

{
  imports = [
    ./config.nix
  ];

  nixpkgs.overlays = [
    (self: super: rec {
      sway = super.sway.overrideAttrs (old: {
        # Do not copy /etc/sway/config.d/* as we set it in config.nix
        postPatch = "";
      });
    })
  ];

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      # Sway extensions
      xwayland
      dmenu
      mako
      kanshi
      glib
      # Terminal Emulator
      sakura
      # Applications
      firefox-beta-bin
    ];
  };
}
