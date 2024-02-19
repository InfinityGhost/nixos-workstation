self: super: {
  gse-resize-window = super.gnomeExtensions.screenshot-window-sizer.overrideAttrs (old: {
    nativeBuildInputs = with super; old.nativeBuildInputs ++ [ perl ];
    patchPhase = ''
      NEW_SIZES='SIZES = [
        [1544, 720], // S22 Ultra 720p
        [2316, 1080], // S22 Ultra 1080p
        [3088, 1440], // S22 Ultra 1440p Native
      ];'

      REGEX="s|SIZES = \[\n+(.+\n)*.+];|''${NEW_SIZES//$'\n'/\\n    }|g"
      perl -0777pe "$REGEX" -i extension.js

      # window title bar is 36 pixels in GTK 3 Adwaita
      REGEX="s|(window\.move_resize_frame\(.+?)newHeight(\);)|\1newHeight + 36\2|g"
      perl -0777pe "$REGEX" -i extension.js
    '';
  });
}
