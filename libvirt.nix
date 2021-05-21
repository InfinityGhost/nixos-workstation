{ pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
  };

  systemd.services."libvirtd" = {
    path = with pkgs; [
      kmod
    ];
  };

  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = smb_host
      netbios name = smb_host
      security = user 
      hosts allow = 192.168.122.0/24 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      games = {
        path = "/games";
        browseable = "yes";
        "acl allow execute always" = "true";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "infinity";
        "force group" = "users";
      };
    };
  };
}
