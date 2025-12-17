{ lib
, makeDesktopItem
, fetchurl
, appimageTools
, symlinkJoin
}:

let
  name = "osu-lazer-appimage";
  version = "2025.702.0-tachyon";

  src = fetchurl {
    hash = "sha256-ZqKM6NKoWqmVnWrB1SSy0YWD+aV2wmtkCi3sUAVecE0=";
    url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
  };

  appimage = appimageTools.wrapType2 {
    inherit name version src;
    extraPkgs = pkgs: with pkgs; [ icu ];
  };

  desktopItem = makeDesktopItem {
    desktopName = "osu!";
    name = "osu";
    exec = name;
    icon = "osu!";
    comment = "Rhythm is just a *click* away";
    type = "Application";
    categories = [ "Game" ];
  };

in symlinkJoin {
  inherit name;
  paths = [ appimage desktopItem ];
  # TODO: fix postBuild
}
