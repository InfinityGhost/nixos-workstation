{ lib, pkgs, ... }:

let
  termcolor = "%F{12}";
  termlinux = "%F{4}";
in
{
  users.defaultUserShell = pkgs.zsh;

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
      cdr = "cd $(git rev-parse --show-toplevel)";
    };
    histSize = 10000;
    interactiveShellInit = ''
      # Inject direnv
      eval "$(direnv hook zsh)" > /dev/null

      [ -f ~/.aliases ] && source ~/.aliases

      export PATH=${lib.my.binDir}:$PATH
    '';
    setOptions = [
      "HIST_IGNORE_DUPS"
      "SHARE_HISTORY"
      "HIST_FCNTL_LOCK"
      "PROMPT_SUBST"
    ];
    promptInit = ''
      NEWLINE=''$'\n'

      # vcs_info Configuration
      autoload -Uz vcs_info

      zstyle ':vcs_info:*' check-for-changes true

      function precmd() {
        vcs_info
        [ -z "''${vcs_info_msg_0_}" ] && eval vcs_info_msg_0_=' '
      }

      if [ "$TERM" = "linux" ]; then
        zstyle ':vcs_info:*' formats ' ${termlinux}[%b]'
        PROMPT='%B${termlinux}%n%f%b@%B${termlinux}%m%b %f%~''${vcs_info_msg_0_}''${NEWLINE}%f  %# '
      else
        zstyle ':vcs_info:*' formats ' ${termcolor}[%b]'
        PROMPT='%B${termcolor}%n%f%b@%B${termcolor}%m%b %f%~''${vcs_info_msg_0_}''${NEWLINE}%f  %# '
      fi
    '';
  };
}
