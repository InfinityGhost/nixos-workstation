self: super: {
  scrcpy = super.scrcpy.overrideAttrs (old: {
    patches = [ ./0001-rotate-center.patch ];
  });
}
