{ pkgs, ... }:

{
  imports = [
    ./nano.nix
    ./packages.nix
    ./printing.nix
    ./terminal.nix
  ];

  time.timeZone = "America/New_York";

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Make users immutable, passwords must be set
  users.mutableUsers = false;

  services.openssh.enable = true;

  system.stateVersion = "22.05";

  fonts.fonts = with pkgs; [
    terminus_font_ttf
    terminus_font
  ];
}
