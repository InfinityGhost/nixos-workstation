{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    git
    manix
    bat
    htop
    btop
    zip
    unzip
    pciutils
    usbutils
    mkpasswd
    direnv
    screen
  ];

  programs.nano.nanorc = ''
    set autoindent
    set tabstospaces
    set tabsize 2
    bind ^Z suspend main
  '';
}
