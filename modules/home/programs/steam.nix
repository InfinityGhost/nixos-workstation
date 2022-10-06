{ lib, config, ... }:

with lib;

let
  vdfPair = key: value:
    if builtins.isAttrs value then
      "\"${key}\"\n{\n\t${vdfAttr value}\n}"
    else if builtins.isList value then
      "\"${key}\"\n{\n\t${vdfList value}\n}"
    else
      "\"${key}\"\t\"${value}\"";

  vdfAttr = attrs: builtins.concatStringsSep "\n"
    (builtins.attrValues (builtins.mapAttrs vdfPair attrs));

  numberedList = list: builtins.listToAttrs
    (builtins.genList
      (n: { name = toString n; value = builtins.elemAt list n; })
      (builtins.length list));

  vdfList = list: (vdfAttr (numberedList list));

  libraryFoldersVdf = attrs: vdfPair "libraryfolders" (numberedList
    (map (n: (name: value: value // { label = name; }) n attrs.${n})
      (builtins.attrNames attrs)));

  path = "${config.home.homeDirectory}/.steam/root/steamapps/libraryfolders.vdf";

  cfg = config.programs.steam;

in {
  options.programs.steam = {
    immutable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable immutable configuration.
      '';
    };

    libraryFolders = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        Attribute set of all steam library folders
        The name will be set as the label
      '';
    };
  };

  config = lib.mkIf cfg.immutable {
    home.file.${path} = {
      text = libraryFoldersVdf cfg.libraryFolders;
      force = true;
    };
  };
}
