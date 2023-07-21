self: super: {
  vertical-overview = super.gnomeExtensions.vertical-overview.overrideAttrs (old: {
    nativeBuildInputs = with self; [
      coreutils
      jq
    ];

    # force current gnome shell version
    installPhase = old.installPhase + ''
      cd $out/share/gnome-shell/extensions/vertical-overview@RensAlthuis.github.com

      f=$(mktemp)
      cat ./metadata.json | \
        jq '."shell-version"=["${super.user.lib.versions.major super.gnome.gnome-shell-extensions.version}"]' > $f

      mv $f ./metadata.json
    '';
  });
}
