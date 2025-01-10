self: super: {
  gse-ddterm-padded = super.gnomeExtensions.ddterm.overrideAttrs (old: {
    nativeBuildInputs = with self; old.nativeBuildInputs ++ [
      perl
      coreutils
      jq
    ];

    # resize and padding
    patchPhase = ''
      SEARCH='if \(this.right_or_bottom\)\n +target_rect\.y \+= workarea\.height - target_rect\.height;'

      REPLACE='const padding = 11;

      target_rect.width /= 2;
      target_rect.x += target_rect.width / 2;

      if (this.right_or_bottom) {
        target_rect.y += workarea.height - target_rect.height - padding;
      } else {
        target_rect.y += padding;
      }'

      REGEX="s|$SEARCH|''${REPLACE//$'\n'/\\n            }|g"

      perl -0777pe "$REGEX" -i ddterm/shell/wm.js

      jq '."shell-version"=["${super.lib.versions.major super.gnome-shell-extensions.version}"]' metadata.json > metadata.json.new
      mv metadata.json{.new,}
    '';
  });
}
