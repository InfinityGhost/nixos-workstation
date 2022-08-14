{ inputs, ... }:

{
  nix = {
    distributedBuilds = true;
    settings.trusted-users = [
      "infinity"
      "@root"
    ];
    extraOptions = ''
      experimental-features = nix-command
      experimental-features = nix-command flakes
    '';

    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };
}
