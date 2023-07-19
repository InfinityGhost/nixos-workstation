{
  networking = {
    hostId = "002199b0";
    useDHCP = false;
    firewall.enable = false;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];

    interfaces.enp39s0.useDHCP = true;
    interfaces.enp39s0.ipv4.addresses = [
      {
        address = "192.168.0.2";
        prefixLength = 24;
      }
    ];

    # workaround for nixpkgs#60900
    dhcpcd.extraConfig = ''
      timeout 1
      noarp
      nodelay
    '';
  };

  services.vpn.servers.mullvad = {};

  services.deluge = {
    enable = true;
    vpns = [ "mullvad" ];
  };

  users.users.deluge.extraGroups = [ "media" ];
  users.groups.media = {};
}
