let
  version = "0.0.20";
  sha256 = "3f7yuxigEF3e8qhCetCHKBtV4XUHsx/iYiaCCXjspYw=";
in self: super: {
  discord = super.discord.overrideAttrs (old: {
    src = super.fetchurl {
      inherit sha256;
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
    };
  });
}
