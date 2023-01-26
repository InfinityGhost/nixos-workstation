{ pkgs, lib, config, nixosConfig, ... }:

{
  programs.steam = {
    immutable = true;
    libraryFolders = {
      Root = {
        path = "${config.home.homeDirectory}/.local/share/Steam";
      };
      Linux = {
        path = "/mnt/Games/SteamLibrary";
      };
      Windows = {
        path = "/mnt/Games/Windows/SteamLibrary";
      };
    };
  };

  programs.direnv.enable = true;

  programs.zsh.profileExtra = ''
    add-path() {
      target_path=$(realpath "$@")
      bin_path=$target_path/bin
      lib_path=$target_path/lib

      if [ -d $target_path ]; then
        if [ -d $bin_path ]; then
          export PATH="$bin_path:$PATH"
          echo "Added '$bin_path' to \$PATH"
        fi

        if [ -d $lib_path ]; then
          export LD_LIBRARY_PATH="$lib_path:$LD_LIBRARY_PATH"
          echo "Added '$lib_path' to \$LD_LIBRARY_PATH"
        fi
      else
        echo "The path '$target_path' does not exist."
        exit 255
      fi
    }

    add-nix-build() {
      for derivation in $(nix build --no-link --print-out-paths ''$@); do
        add-path $derivation
      done
    }
  '';
}
