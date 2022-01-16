{ pkgs, ... }:

let
  termcolor = "%F{12}";
in
{
  users.defaultUserShell = pkgs.zsh;

  programs.zsh = {
    enable = true;
    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -l";
    };
    histSize = 10000;
    interactiveShellInit = ''
      # Inject direnv
      eval "$(direnv hook zsh)" > /dev/null

      # Aliases
      [ -f ~/.aliases ] && source ~/.aliases

      # Local bin directory
      export PATH=$PATH:~/.local/bin
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
      zstyle ':vcs_info:*' formats ' ${termcolor}[%b]'

      function precmd() {
        vcs_info
        [ -z "''${vcs_info_msg_0_}" ] && eval vcs_info_msg_0_=' '
      }

      PROMPT='%B${termcolor}%n%f%b@%B${termcolor}%m%b %f%~''${vcs_info_msg_0_}''${NEWLINE}%f  %# '
    '';
  };
}
