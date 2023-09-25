self: super: let
  # inherit (super.user.lib) versions;
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
        jq '."shell-version"=["${shellVersion}"]' > $f

      mv $f ./metadata.json
    '';
  });

in {
  focus-window = forceExtension {
    pkg = super.gnomeExtensions.focus-window;
    uuid = "focus-window@chris.al";
  };
}
