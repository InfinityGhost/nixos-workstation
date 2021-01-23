{
  # Make users immutable, passwords must be set
  users.mutableUsers = false;

  users.users.infinity = {
    isNormalUser = true;
    hashedPassword = "$6$tHKIF.z6$YxikRiScslszerVWhawoFQZW86yFPXjHsurip3hwbldoFQ.y79.onzEd73Dr7zYn0W9mehi6bXfGz6Z3QQlHC0";
    extraGroups = [
      "wheel"
      "libvirt"
    ];
  };
}
