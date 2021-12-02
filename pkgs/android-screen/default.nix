{ lib
, symlinkJoin
, scrcpy
, makeDesktopItem
}:

let
  pname = "android-screen";

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "${scrcpy}/bin/scrcpy -Sw";
    icon = "androidstudio";
    comment = "Android Screen shortcut with scrcpy";
    desktopName = "Android Screen";
  };

in symlinkJoin {
  name = pname;
  paths = [ desktopItem ];
}