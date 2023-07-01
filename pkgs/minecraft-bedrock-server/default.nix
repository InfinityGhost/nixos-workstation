{ fetchzip
, writers
, lib
, patchelf
, stdenv
, buildFHSUserEnv
}:

let
  pname = "minecraft-bedrock-server";
  name = pname;
  version = "1.20.1";
  buildNumber = "02";

  src = fetchzip {
    stripRoot = false;
    url = "https://minecraft.azureedge.net/bin-linux/bedrock-server-${version}.${buildNumber}.zip";
    sha256 = "DjgediOjHdcRg66dEXVgMxe84hgh+ptS63xpMVzdoqw=";
  };

in buildFHSUserEnv {
  inherit name;

  targetPkgs = pkgs: with pkgs; [
    curl
  ];

  runScript = writers.writeBash "bedrock_server" ''
    cpv() {
      [ ! -f ./$1 ] && cp -v ${src}/$1 ./$1
    }

    cpv server.properties
    cpv allowlist.json

    ${src}/bedrock_server
  '';
}
