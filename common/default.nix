{ pkgs, ... }:

{
  imports = [
    ./nano.nix
    ./nix.nix
    ./packages.nix
    ./printing.nix
    ./terminal.nix
    ./users.nix
  ];

  time.timeZone = "America/New_York";

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  system.stateVersion = "22.05";

  fonts.fonts = with pkgs; [
    terminus_font_ttf
    terminus_font
  ];
}
