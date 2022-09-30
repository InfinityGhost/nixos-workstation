{ pkgs, ... }:

let
  dotnet-sdk = with pkgs.dotnetCorePackages; combinePackages [
    sdk_5_0
    sdk_6_0
  ];
in
{
  # Make users immutable, passwords must be set
  users.mutableUsers = false;

  users.users.infinity = {
    isNormalUser = true;
    uid = 1000;
    hashedPassword = "$6$tHKIF.z6$YxikRiScslszerVWhawoFQZW86yFPXjHsurip3hwbldoFQ.y79.onzEd73Dr7zYn0W9mehi6bXfGz6Z3QQlHC0";
    extraGroups = [
      "wheel"
      "libvirtd"
      "networkmanager"
      "users"
    ];
    packages = with pkgs; [
      neofetch
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC207e74mAriWEqokRJhUXZohTfzCD0CCC+5t68zqJQog2XkJRbh2qzB8KjP6NPOB2xMm03elaeP+UwdUrK9iuT/HIYv+ofoSHoXxsSoPWRjO07HWGTKEtnt4q623hOeYHiKhCoGsFgf42S9KHFaFes/bdQv//+ywooTxoIf2Rke92yvCP0bOL/Fd6Lr15ze3IP4HtEWrD6juaS77M8H3ZxCFIMrapLP2yXC1MqZAudwdpGWMbny07aEaF7pG/6CSqPHKO+ItE4sQc7BzPf9hxMxVyRgOIe8f69GoFqUc+Ak9xQSkRVr6Ty+A0oN6KAbnCnFYrrsz4fjvRpYjwNev8zxoC2rR1QivHc39Pos2Rf7rhGZPjZaEJ8NSX/4Gx+yQ9hxDbPjTiuqY+H8Vh+5oeu1l+/igjwwvQ/NY/ke6vETTRx88rJm6Rk81UP9U3IJVZYatqCgHHFtYii6gRWmDhLA/g31Ip5DAKlPypVOUt1ZqzPGYIlIIjk3RWAYAekRWiBUw1k+LRv2ck6IYTmNJBMibCCsOTo7+a+m1ijaz7/BX9zrmXexY4NWCJiUkunO5cJImlMe9I4dZVJsMuZDH1HY5S14nxQue7+hYw7l+qis+WAdYNOlk78VKfKoutVDdMQdUMURrC5mc54HwcV5LcuIftq7uiPftA07Rrw6PkUxQ== infinity@termux"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDbn1x8eTkbzK7OH8cO6ctamFS7iIlxc0OOr1MLE8FWup2pizJa5wYLno+BETa2SLmqbNasPt+YjEom0AjQl1pOYDSt2t3gsqoHq/odigFzp6B9dS7u2UuVxFifbAPolsho/Z2hKi/mRDZD9E47dCWBK1picqKfM6UyerKPb1YkXtrvBRFEc5k4SXSBSyoGhwLjrldqM/RYXxGVJTpUAD4ZSKxU3QsMIkE6jfP0fICdkPy7GY5p1FDd+IvpGQoiTfOM9cCtW60d1hDAEDyrBR0/voPGCL3Vq0fLPZMFvQLzNfHk6E2jrTMhVp/9q9Hj3xihiVvUThgHNeHFOwlJmSd1uIv6U1ztgXd6NG6FMLrMAHukI5lDTP5a4l5NxKnT9IloW4UK9fFUDxloupumsdwyfzLeSOg0tFO6J42gQX4pFYMfWe+dTJung/Wh848PF5fXPclO+SaKKhiRuE+Jw53//OHyV2NZXV301aj13ZM5d7YurnfoA2PV6azn6bhu0J6pMFsJn+Mb6gHPZzkrJ570cTNo9YB3mdQoHDGD5z2DJ5mQ4pfabhQImBjJ94aDbZnlENrxrCExTECqqmlv/7a30nGcc1+d8TVmRSLRBE4X1FKwMizLKtjDGBJgyWTMWZsN/2v1BuyD33C27nV8HUVHR6QEX7JztzGb5VNGKsnsAQ== infinity@nixos-toshiba"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHBfhFoHCSwPszvGEnxbM9s63Xqg012SsCWBBqpo/hoDV/tp/J068Cp0eQf13WUWWcSqU/2HOFkJSkD/kl0IJ8FXafjwUj5ERN1P1UxEB6d+Yvpxp0fK/kZIzmooSbrJhto+ERR0HxcLjtXKTKDZrE9wV0NJBJGpDvqkEjvy2+zsEQXLCm6K2fl2jiih262r0OJtzqxEbhWhS3I4VDfNOfN/rc9nYyk9Y+HF7bjp/U58Gv6KkMmyTiREF1fEPFHa2DAsQyN9bBf/If4ejW0/1/2ijB/VzlAFwIBAHNFFnnA6X8bv0JGGaxD10Zg53gH6XlVe3oHxplK08GM2Eun0hv5i+6pBY+D5Rr0Yz5OOQ9BYWHGG8I/opDAznJEYL9kqyvskXN/TdLh3NP9AVdMtKdPo1HDn4mYxXX8SItYKMkSvZHEtOcXq9RdEkh+8dItn8wO3Ymqa3GhhsX4gEYTaWJ4kEzI2nacTC/aKjE4Js22UkHaTwCBqBLKOaLhKSLmGKf8n6BdXzlhEJhEdb6w1ubZ0zT+jtU36RrWeYn2+kVNrNefCBud3fkPNYwpIAoKUEMjAaVIhCPSz+TtKzU9NIfCfK3KYgQD03QzaqLSFALuEARHYTtSofffjwwJC+K4LV7tY8eqsnJ4mvB+4MWjrSn8j/SRIPXprdzfYK8dbqlpw== infinity@nixos-pi4"
    ];
  };
}
