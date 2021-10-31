{ jetbrains
, fetchurl
}:

let
  version = "2021.2.2";
in jetbrains.rider.overrideAttrs (old: {
  inherit version;
  src = fetchurl {
    url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
    sha256 = "17xx8mz3dr5iqlr0lsiy8a6cxz3wp5vg8z955cdv0hf8b5rncqfa";
  };
})