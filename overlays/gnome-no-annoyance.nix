self: super: let
  shellVersion = super.lib.versions.major super.gnome.gnome-shell-extensions.version;
  uuid = super.gnomeExtensions.noannoyance.extensionUuid;
in {
  noannoyance = super.gnomeExtensions.noannoyance.overrideAttrs (old: {
    nativeBuildInputs = with self; [
      coreutils
      jq
    ];

    installPhase = old.installPhase + ''
      f=$(mktemp)
      cat $src/metadata.json | \
      jq '."shell-version"=["${shellVersion}"]' > $f

      mv $f $out/share/gnome-shell/extensions/${uuid}/metadata.json
    '';
  });
}
