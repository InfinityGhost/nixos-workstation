let
  mkContainer = name: {
    enable = true;
    execConfig = {
      Timezone = "Bind";
      Hostname = "${name}-container";
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
in
{
  systemd.nspawn."fedora" = mkContainer "fedora";
  systemd.nspawn."ubuntu" = mkContainer "ubuntu";
}
