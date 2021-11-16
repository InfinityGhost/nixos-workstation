let
  mkVPN = name: {
    config = "config /root/.openvpn/${name}/${name}.ovpn";
    autoStart = false;
  };
in
{
  networking.useDHCP = false;
  networking.interfaces.enp39s0.useDHCP = true;

  networking.firewall.enable = false;

  services.openvpn.servers = {
    mullvad = mkVPN "mullvad";
  };
}
