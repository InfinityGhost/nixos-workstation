{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    git
    manix
    htop
    btop
    zip
    unzip
    pciutils
    usbutils
    mkpasswd
    direnv
  ];

  programs.nano.nanorc = ''
    set autoindent
    set tabstospaces
    set tabsize 2
    bind ^Z suspend main
  '';
}
