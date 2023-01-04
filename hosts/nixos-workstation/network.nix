{
  networking = {
    hostId = "002199b0";
    useDHCP = false;
    interfaces.enp39s0.useDHCP = true;
    firewall.enable = false;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
  };

  services.vpn.servers.mullvad = {};

  services.deluge = {
    enable = true;
    vpns = [ "mullvad" ];
  };
}
