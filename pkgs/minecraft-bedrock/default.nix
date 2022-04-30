{ appimageTools
, fetchurl
, makeDesktopItem
}:

let
  pname = "minecraft-bedrock";
  name = pname;
  version = "0.3.0";
  buildNumber = "678";

  src = fetchurl {
    url = "https://github.com/ChristopherHX/linux-packaging-scripts/releases/download/v${version}-${buildNumber}/Minecraft_Bedrock_Launcher-x86_64-0.0.${buildNumber}.AppImage";
    sha256 = "04p9kc08jd1yvyrjr6g2wbp8a0f76x0kfp4bgcj7v0d654vy6p1p";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = "minecraft-launcher";
    comment = "Minecraft Bedrock Launcher";
    desktopName = "Minecraft Bedrock";
    categories = [ "Game" ];
  };

in appimageTools.wrapType2 rec {
  inherit name src;

  extraInstallCommands = ''
    mkdir -p $out/share
    cp -rt $out/share ${desktopItem}/share/applications
  '';
}