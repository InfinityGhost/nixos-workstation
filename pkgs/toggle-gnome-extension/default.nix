{ lib
, gnome
, writers
, symlinkJoin
}:

let
  pname = "toggle-gnome-extension";
  bin = writers.writeBashBin pname ''
    bin=${gnome.gnome-shell}/bin/gnome-extensions
    if [ ! -z "$1" ]; then
      [ $($bin list --enabled | grep $1) ] && $bin disable $1 || $bin enable $1
    else
      echo "No extension specified."
      $bin list
    fi
  '';
in symlinkJoin {
  name = pname;
  paths = [ bin ];
}