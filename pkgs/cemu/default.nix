{ lib
, makeDesktopItem
, fetchzip
, fetchFromGitHub
, symlinkJoin
, writers
, wineWowPackages
, python3Full
, bluez
, location ? "$HOME/.config/cemu"
}:

with lib;

let
  pname = "cemu";
  version = "1.22.13";
  hookVersion = "1159_0573";

  cemu = fetchzip {
    name = "cemu-bin";
    url = "https://cemu.info/releases/cemu_${version}.zip";
    sha256 = "1szdcb6vlklghc8r1611imh2pai6gb2rrwrrwi530sqdy0ygffb6";
  };

  cemuhook = fetchzip {
    name = "cemuhook-bin";
    url = "https://files.sshnuke.net/cemuhook_${hookVersion}.zip";
    sha256 = "0wnmrvbfglwcnwypbj2vvyy8xxfpnrcim7sy92jr6hx2ywaha8lz";
    stripRoot = false;
  };

  icon = builtins.fetchurl {
    url = "https://wiki.cemu.info/images/3/32/CemuLogo2.png";
    sha256 = "sha256:1jdp090avcjhkdd4fi2yapflf66y3dzdxgd5rc0gpc1dz357k97v";
  };

  script = writers.writeBashBin pname ''
    export WINEARCH="win64"
    export WINEPREFIX="${location}/.pfx"
    export WINEDLLOVERRIDES="dbghelp=n,b"

    CEMUDIR="${location}/${version}"
    SHARED="${location}/shared"

    createDirectories() {
      [ ! -d "$CEMUDIR" ] && mkdir -p "$CEMUDIR"
      [ ! -d "$SHARED" ] && mkdir -p "$SHARED"
    }

    createPrefix() {
      if [ ! -d $WINEPREFIX ]; then
        echo "Creating prefix..."
        ${wineWowPackages.staging}/bin/wineboot
      fi
    }

    installCemu() {
      if [ ! -f "$CEMUDIR/Cemu.exe" ]; then
        echo "Installing cemu ${version}..."
        for file in ${cemu}/*; do
          linkfs "$file" "$CEMUDIR/$(basename "$file")"
        done

        echo "Installing cemuhook for ${version}..."
        for file in ${cemuhook}/*; do
          linkfs "$file" "$CEMUDIR/$(basename "$file")"
        done

        rm "$CEMUDIR/graphicPacks"
        mkdir "$CEMUDIR/graphicPacks"
      fi
    }

    linkfs() {
      [ ! -e "$2" ] && ln -sv "$1" "$2"
    }

    linkFiles() {
      [ ! -d "$SHARED" ] && mkdir -p "$SHARED"
      files=("settings.xml" "cemuhook.ini" "keys.txt")
      for file in ''${files[@]}; do
        local sharedFile="$SHARED/$file"
        local linkFile="$CEMUDIR/$file"

        [ ! -f "$sharedFile" ] && touch "$sharedFile"
        linkfs "$sharedFile" "$linkFile"
      done
    }

    linkDirs() {
      dirs=("mlc01" "controllerProfiles" "graphicPacks")
      for dir in ''${dirs[@]}; do
        local sharedDir="$SHARED/$dir"
        local linkDir="$CEMUDIR/$dir"

        [ ! -d "$sharedDir" ] && mkdir -p "$sharedDir"
        linkfs "$sharedDir" "$linkDir"
      done
    }

    linkShaderCache() {
      # Handle shaderCache linking
      local sharedShaderCache="$SHARED/shaderCache"
      local shaderCache="$CEMUDIR/shaderCache"

      local sharedTransferable="$sharedShaderCache/transferable"
      local transferable="$shaderCache/transferable"

      if [ "$(readlink -f "$transferable")" != "$(readlink -f "$sharedTransferable")" ]; then
        echo "Linking shaderCache..."
        rm "$shaderCache"
        mkdir -p "$sharedTransferable" "$shaderCache"

        linkfs "$sharedTransferable" "$transferable"

        for file in ${cemu}/shaderCache/*; do
          linkfs "$file" "$shaderCache/$(basename "$file")"
        done
      fi
    }

    createDirectories
    createPrefix
    installCemu
    linkFiles
    linkDirs
    linkShaderCache

    cd $CEMUDIR
    ${wineWowPackages.staging}/bin/wine ./Cemu.exe

    if [ ! -z "$CEMUDIR/settings.xml" ]; then
      mv "$CEMUDIR/settings.xml" "$SHARED/settings.xml"
      ln -s "$SHARED/settings.xml" "$CEMUDIR/settings.xml"
    fi
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "${script}/bin/${pname}";
    inherit icon;
    comment = "Closed-source Wii U Emulator";
    desktopName = "Cemu";
    categories = [ "Game" ];
  };

  ds4drv-cemuhook = python3Full.pkgs.buildPythonPackage rec {
    pname = "ds4drv-cemuhook";
    version = "28aa88cc8b3599227d95a3fb89c0df12a0e08fd6";

    src = fetchFromGitHub {
      owner = "TheDrHax";
      repo = pname;
      rev = version;
      sha256 = "1p4w40vad60xylj8irzxgk7p6d6j78wlphrhn875f05gpps9lqjb";
    };

    propagatedBuildInputs = with python3Full.pkgs; [
      setuptools
      evdev
      pyudev
      attrs
      pybluez
    ];

    buildInputs = [ bluez ];
  };

  ds4drv-cemuhook-run = writers.writeBashBin "ds4drv" ''
    ${ds4drv-cemuhook}/bin/ds4drv --udp --hidraw "$@"
  '';

in symlinkJoin {
  name = pname;
  paths = [ desktopItem script ds4drv-cemuhook-run ];
}
