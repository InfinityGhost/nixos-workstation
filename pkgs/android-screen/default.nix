{ lib
, stdenv
, scrcpy
, makeDesktopItem
}:

let
  name = "android-screen";
  version = "1.0.0";

  desktopItem = makeDesktopItem {
    inherit name;
    exec = "${scrcpy}/bin/scrcpy -Sw";
    icon = "androidstudio";
    comment = "Android Screen shortcut with scrcpy";
    desktopName = "Android Screen";
  };

in stdenv.mkDerivation {
  inherit name version;

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/share
    cp -rt $out/share ${desktopItem}/share/applications
  '';
}