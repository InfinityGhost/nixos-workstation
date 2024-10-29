self: super: {
  scrcpy = super.scrcpy.overrideAttrs (old: {
    patches = [ ./0001-rotate-center.patch ];

    fixupPhase = ''
      rm $out/share/applications/scrcpy-console.desktop

      file="$out/share/applications/scrcpy.desktop"
      args="-SwdK --window-borderless"
      REGEX="s|(Exec=.*)(scrcpy)|\1'\2 $args'|g"
      ${super.perl}/bin/perl -0777pe "$REGEX" -i $file

      cat $file
    '';
  });
}
