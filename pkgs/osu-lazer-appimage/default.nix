{ lib
, makeDesktopItem
, fetchurl
, appimageTools
}:

let
  name = "osu-lazer-appimage";
  version = "2024.302.1";
  hash = "sha256-vYG3viY9GBtgaY8ThCSWss+zzjAyVa4fmrWrQdYcUow=";

in appimageTools.wrapType2 {
  inherit name version;

  src = fetchurl {
    inherit hash;
    url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
  };

  extraPkgs = pkgs: with pkgs; [ icu ];
}
