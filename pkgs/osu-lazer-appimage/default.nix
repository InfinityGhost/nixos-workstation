{ lib
, makeDesktopItem
, fetchurl
, appimageTools
}:

let
  name = "osu-lazer-appimage";
  version = "2024.521.2";
  hash = "sha256-QVDgY04PmGJ/eOfes/qBAbBKsk9uOaqLjwZSQH+F9ro=";

in appimageTools.wrapType2 {
  inherit name version;

  src = fetchurl {
    inherit hash;
    url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
  };

  extraPkgs = pkgs: with pkgs; [ icu ];
}
