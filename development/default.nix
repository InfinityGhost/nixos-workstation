{ pkgs, ... }:

let
  dotnet-sdk = with pkgs.dotnetCorePackages; combinePackages [
    sdk_5_0
    sdk_6_0
  ];
in
{
  users.users.infinity = {
    packages = with pkgs; [
      # SDK
      dotnet-sdk
      # IDE
      vscode
      jetbrains.rider
    ];
  };
}
