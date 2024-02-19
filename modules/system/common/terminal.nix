{ lib, pkgs, ... }:

let
  termcolor = "%F{12}";
  termlinux = "%F{4}";
in
{
  users.defaultUserShell = pkgs.zsh;

  fonts.packages = with pkgs; [
    terminus_font
    terminus_font_ttf
    ubuntu_font_family
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -l";
      grep  = "grep --color=auto";
      tohex = "od -An -tx1";
      clip = "xclip -selection clipboard";
      tb = "nc termbin.com 9999";
      tbc = "tb | clip";
      fp = "git fetch -p --all";
      virsh = "virsh --connect=qemu:///system";
      findtext = "grep -rnw . -e";
      nb = "nix build $@ --no-link --print-out-paths";
      nbo = "nix-store -qR --include-outputs $(nix-store -qd $(nb $@)) | grep -v '\.drv$'";
    };
    histSize = 10000;
    interactiveShellInit = ''
      # Inject direnv
      eval "$(direnv hook zsh)" > /dev/null

      export PATH=${lib.my.filesystem.binDir}:$PATH
    '';
    setOptions = [
      "HIST_IGNORE_DUPS"
      "SHARE_HISTORY"
      "HIST_FCNTL_LOCK"
      "PROMPT_SUBST"
    ];
    promptInit = ''
      NEWLINE=''$'\n'

      case $TERM in
        linux) zsh_color='%F{4}';;
        *) zsh_color='%F{12}';;
      esac

      autoload -Uz vcs_info
      zstyle ':vcs_info:*' check-for-changes true
      zstyle ':vcs_info:*' formats '%c%u%~@%b'
      zstyle ':vcs_info:*' unstagedstr '%F{9}'
      zstyle ':vcs_info:*' stagedstr '%F{10}'

      function precmd() {
        vcs_info
        zsh_info="''${vcs_info_msg_0_:-%~}"
      }

      PROMPT='%B''${zsh_color}%n%f%b@%B''${zsh_color}%m%b%f ''${zsh_info}%f %(1j.%j.)''${NEWLINE}  %# '

      function cdr() {
        d="$(git rev-parse --show-toplevel)"
        [ -d "$d" ] && cd "$d"
      }

      function add-path() {
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

      function add-nix-build() {
        for drv in $(nix build --no-link --print-out-paths ''$@); do
          add-path $drv
        done
      }
    '';
  };
}
