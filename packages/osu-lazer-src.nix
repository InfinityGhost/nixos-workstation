{ pkgs, ... }:

let
  osu-lazer-src = pkgs.writers.writeBashBin "osu-lazer" ''
    ENVDIR="/repos/osu"
    COMMAND="dotnet run --project /repos/osu/osu.Desktop/osu.Desktop.csproj -c Release -r linux-x64 -v minimal"
    if [ "$PWD" != "$ENVDIR" ]; then
      direnv exec "$ENVDIR" $COMMAND $@
    else
      exec $COMMAND $@
    fi
  '';
in
{
  environment.systemPackages = [
    osu-lazer-src
  ];
}