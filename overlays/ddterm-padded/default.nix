self: super: {
  ddterm-padded = super.gnomeExtensions.ddterm.overrideAttrs (old: {
    patches = [ ./0001-padding.patch ];

    nativeBuildInputs = with self; old.nativeBuildInputs ++ [
      coreutils
      jq
    ];

    # force gnome shell version
    installPhase = old.installPhase + ''
      cd $out/share/gnome-shell/extensions/ddterm@amezin.github.com

      f=$(mktemp)
      cat ./metadata.json | \
        jq '."shell-version"=["${super.lib.versions.major super.gnome.gnome-shell-extensions.version}"]' > $f

      mv $f ./metadata.json
    '';
  });
}
