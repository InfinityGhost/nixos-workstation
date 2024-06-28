{ lib
, makeDesktopItem
, fetchurl
, appimageTools
}:

let
  name = "osu-lazer-appimage";
  version = "2024.625.2";

in appimageTools.wrapType2 {
  inherit name version;

  src = fetchurl {
    hash = "sha256-YAXcnQKSvVDBfhHFkfKCeSwdpsHHOTmLHIKcOSHjq1E=";
    url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
  };

  extraPkgs = pkgs: with pkgs; [ icu ];
}
