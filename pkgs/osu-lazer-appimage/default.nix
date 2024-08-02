{ lib
, makeDesktopItem
, fetchurl
, appimageTools
}:

let
  name = "osu-lazer-appimage";
  version = "2024.731.0";

in appimageTools.wrapType2 {
  inherit name version;

  src = fetchurl {
    hash = "sha256-6BxHRM7hC+v61BVqSFTzGpi7EyZQeo7kWua0CkrWiPM=";
    url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
  };

  extraPkgs = pkgs: with pkgs; [ icu ];
}
