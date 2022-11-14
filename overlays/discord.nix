let
  version = "0.0.21";
  sha256 = "sha256-KDKUssPRrs/D10s5GhJ23hctatQmyqd27xS9nU7iNaM=";
in self: super: {
  discord = super.discord.overrideAttrs (old: {
    src = super.fetchurl {
      inherit sha256;
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
    };
  });
}
