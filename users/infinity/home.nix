{ pkgs, nixosConfig, ... }:

{
  home.stateVersion = nixosConfig.system.stateVersion;

  home.packages = with pkgs; [
    neofetch
  ];
}
