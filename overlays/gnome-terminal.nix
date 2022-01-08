self: super: {
  gnome = super.gnome.overrideScope' (gnomeSelf: gnomeSuper: {
    gnome-terminal = gnomeSuper.gnome-terminal.overrideAttrs (old: {
      patches = [
        (super.fetchurl {
          url = "https://aur.archlinux.org/cgit/aur.git/plain/transparency.patch?h=gnome-terminal-transparency";
          sha256 = "sha256-jnxy8LrTDUorqYrNFKrZVnMcoLw1IQKfwuGFiijuEI0=";
        })
      ];
    });
  });
}