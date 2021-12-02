let
  mkVPN = name: {
    config = "config /root/.openvpn/${name}/${name}.ovpn";
    autoStart = false;
  };
in
{
  networking = {
    hostName = "nixos-workstation";
    useDHCP = false;
    interfaces.enp39s0.useDHCP = true;
    firewall.enable = false;
  };

  services.openvpn.servers = {
    mullvad = mkVPN "mullvad";
  };
}
