self: super: {
  scrcpy = super.scrcpy.overrideAttrs (old: let
    version = "3.0.2";

    prebuilt_server = super.fetchurl {
      name = "scrcpy-server";
      inherit version;
      url = "https://github.com/Genymobile/scrcpy/releases/download/v${version}/scrcpy-server-v${version}";
      hash = "sha256-4Z/gJL+jNngJSUQHrWyoCab2532slemfhbp1FE4Lo10=";
    };
  in
  {
    inherit version;

    src = super.fetchFromGitHub {
      owner = "GenyMobile";
      repo = "scrcpy";
      rev = "v${version}";
      hash = "sha256-6CViFgQuazvKGPHGpityEI/mpgOmIBA6LTEHobWybV0=";
    };

    patches = [ ./0001-rotate-center.patch ];

    fixupPhase = ''
      rm $out/share/applications/scrcpy-console.desktop

      file="$out/share/applications/scrcpy.desktop"
      args="-SwdK --window-borderless"
      REGEX="s|(Exec=.*)(scrcpy)|\1'\2 $args'|g"
      ${super.perl}/bin/perl -0777pe "$REGEX" -i $file

      cat $file
    '';

    postInstall = old.postInstall + ''
      ln -sfv "${prebuilt_server}" "$out/share/scrcpy/scrcpy-server"
    '';
  });
}
