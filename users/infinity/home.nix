{ pkgs, nixosConfig, ... }:

{
  home.stateVersion = nixosConfig.system.stateVersion;
}
