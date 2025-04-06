{
  networking = {
    hostId = "002199b0";
    useDHCP = false;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];

    interfaces.enp39s0.useDHCP = true;

    # workaround for nixpkgs#60900, slow shutdowns
    dhcpcd.extraConfig = ''
      timeout 1
      noarp
      nodelay
    '';
  };

  users.groups.media = {};
}
