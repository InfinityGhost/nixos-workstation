let
  mkVPN = name: {
    config = "config /var/lib/openvpn/${name}/${name}.ovpn";
    autoStart = false;
  };
in
{
  networking = {
    hostId = "002199b0";
    useDHCP = false;
    interfaces.enp39s0.useDHCP = true;
    firewall.enable = false;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };

  services.openvpn.servers = {
    mullvad = mkVPN "mullvad";
  };
}
