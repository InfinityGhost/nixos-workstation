{ lib, config, pkgs, ... }:

let
  cfg = config.development.dotnet;

  dotnet-sdk = with pkgs.dotnetCorePackages; combinePackages [
    sdk_5_0
    sdk_6_0
  ];
in
{
  options.development.dotnet = with lib; {
    enable = mkEnableOption ".NET Development Environment";
  };

  config = lib.mkIf cfg.enable {
    users.users.infinity.packages = with pkgs; [
      # SDK
      dotnet-sdk
      # IDE
      vscode
      jetbrains.rider
    ];
  };
}
