{ writeShellApplication
, makeDesktopItem
, symlinkJoin

, unstable # [ scrcpy ]
}:

let
  name = "android-screen";
  desktopName = "Phone";
  icon = "androidstudio";

  script = writeShellApplication {
    inherit name;

    runtimeInputs = [
      unstable.scrcpy
    ];

    text = ''
      ip=''${1:-""}
      port=''${2:-""}

      if [ -z "$ip" ] && [ -z "$port" ]; then
        scrcpy -Swd
      else
        scrcpy -Sw --tcpip="$ip:$port"
      fi
    '';
  };

  desktopItem = makeDesktopItem {
    inherit name desktopName icon;
    exec = "${script}";
    comment = "Android Screen shortcut with scrcpy";
  };

in symlinkJoin {
  inherit name;
  paths = [ script desktopItem ];
}
