{
  systemd.nspawn."fedora" = {
    enable = true;
    execConfig = {
      Timezone = "Bind";
      Hostname = "fedora-container";
    };
    filesConfig = {
      Bind = [ "/repos" ];
      Volatile = false;
    };
    networkConfig = {
      Private = true;
      VirtualEthernet = true;
      Bridge = "virbr0";
    };
  };
  systemd.nspawn."ubuntu" = {
    enable = true;
    execConfig = {
      Timezone = "Bind";
      Hostname = "ubuntu-container";
    };
    filesConfig = {
      Bind = [ "/repos" ];
      Volatile = false;
    };
    networkConfig = {
      Private = true;
      VirtualEthernet = true;
      Bridge = "virbr0";
    };
  };
}
