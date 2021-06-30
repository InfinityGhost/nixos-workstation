{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    remmina
    teams
  ];

  services.openvpn.servers = {
    officeVPN = {
      config = "config /root/openvpn/corp/corp.ovpn";
      autoStart = false;
    };
  };
}
