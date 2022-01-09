self: super: {
  ddterm-padded = super.gnomeExtensions.ddterm.overrideAttrs (old: {
    patches = [
      ./padding.patch
    ];
  });
}