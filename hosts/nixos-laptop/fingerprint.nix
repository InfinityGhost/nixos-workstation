{ pkgs, ... }:

{
  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-vfs0090;
    };
  };

  # disables fingerprint over ssh?
  security.pam.services.sshd.fprintAuth = false;
}
