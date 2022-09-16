self: super: {
  android-screen = super.callPackage ./android-screen {};
  cemu = super.callPackage ./cemu {};
  minecraft-bedrock = super.callPackage ./minecraft-bedrock {};
  nix-direnv-init = super.callPackage ./nix-direnv-init {};
  toggle-gnome-extension = super.callPackage ./toggle-gnome-extension {};
}
