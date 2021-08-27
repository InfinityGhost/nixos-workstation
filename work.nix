{ pkgs, ... }:

let
  work-rdp = pkgs.writers.writeBashBin "work-rdp" ''
    ${pkgs.remmina}/bin/remmina -c `${pkgs.coreutils}/bin/readlink -f ~/.local/share/remmina/*work-computer*.remmina`
  '';
  work-desktop-rdp = pkgs.makeDesktopItem {
    name = "work-rdp";
    desktopName = "Work Computer";
    exec = "${work-rdp}/bin/work-rdp";
    icon = "${pkgs.remmina}/share/icons/hicolor/scalable/apps/org.remmina.Remmina.svg";
    categories = "Network;";
  };
in
{
  users.users.infinity.packages = with pkgs; [
    remmina
    teams
    work-rdp
    work-desktop-rdp
  ];
}
