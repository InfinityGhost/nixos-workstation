self: super: let
  inherit (super.user.lib) versions;
  inherit (builtins) readDir;

  forceExtension = { pkg, uuid, shellVersion ? super.gnome.gnome-shell-extensions.version }: pkg.overrideAttrs (old: {
    nativeBuildInputs = with self; [
      coreutils
      jq
    ];

    # force gnome shell version
    installPhase = old.installPhase + ''
      cd $out/share/gnome-shell/extensions/${uuid}

      f=$(mktemp)
      cat ./metadata.json | \
        jq '."shell-version"=["${versions.major shellVersion}"]' > $f

      mv $f ./metadata.json
    '';
  });

in {
  vertical-overview = forceExtension {
    pkg = super.gnomeExtensions.vertical-overview;
    uuid = "vertical-overview@RensAlthuis.github.com";
  };
}
