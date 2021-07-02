{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    remmina
    teams
  ];
}
