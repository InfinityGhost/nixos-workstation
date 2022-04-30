self: super: {
  discord = super.discord.overrideAttrs (old: rec {
    version = "0.0.17";
    src = super.fetchurl {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "sha256-NGJzLl1dm7dfkB98pQR3gv4vlldrII6lOMWTuioDExU=";
    };
  });
}
