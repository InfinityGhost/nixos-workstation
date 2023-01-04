let
  version = "0.0.22";
  sha256 = "sha256-F1xzdx4Em6Ref7HTe9EH7whx49iFc0DFpaQKdFquq6c=";
in self: super: {
  discord = super.discord.overrideAttrs (old: {
    src = super.fetchurl {
      inherit sha256;
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
    };
  });
}
