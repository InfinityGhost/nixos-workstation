{ lib
, makeDesktopItem
, fetchurl
, appimageTools
, symlinkJoin
}:

let
  name = "osu-lazer-appimage";
  version = "2024.1219.2";

  src = fetchurl {
    hash = "sha256-qNkuiDA4LiWqwpYFrBDvV5VoOwO6Ei8jHGIgVKSErdo=";
    url = "https://github.com/ppy/osu/releases/download/${version}/osu.AppImage";
  };

  appimage = appimageTools.wrapType2 {
    inherit name version src;
    extraPkgs = pkgs: with pkgs; [ icu ];
  };

  data = appimageTools.extract {
    inherit name version src;
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
  postBuild = ''
    mkdir -p $out/share/icons
    install -D ${data}/*.png $out/share/icons
  '';
}
