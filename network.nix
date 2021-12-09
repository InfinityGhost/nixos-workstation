let
  mkVPN = name: {
    config = "config /var/lib/openvpn/${name}/${name}.ovpn";
    autoStart = false;
  };
in
{
  networking = {
    hostName = "nixos-workstation";
    hostId = "002199b0";
    useDHCP = false;
    interfaces.enp39s0.useDHCP = true;
    firewall.enable = false;
  };

  services.openvpn.servers = {
    mullvad = mkVPN "mullvad";
  };
}
