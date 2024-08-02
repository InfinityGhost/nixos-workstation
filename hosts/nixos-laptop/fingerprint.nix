{ pkgs, ... }:

{
  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-vfs0090;
    };
  };

  security.pam.services = {
    sshd.fprintAuth = false; # disables fingerprint over ssh
    login.enableGnomeKeyring = true;
    gdm.enableGnomeKeyring = true;
  };
}
