{ pkgs, ... }:

{
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

      if [ "$TERM" != "linux" ] && [ "$TERM_PROGRAM" != "vscode" ] && [ -z "''${RIDER_VM_OPTIONS+x}" ]; then
        # vcs_info Configuration
        autoload -Uz vcs_info
        zstyle ':vcs_info:*' check-for-changes true
        zstyle ':vcs_info:*' formats '%K{12}%F{4}◤%f %b %k%F{12}◤%f'

        function precmd() {
          vcs_info

          [ -z ''${vcs_info_msg_0_} ] && eval vcs_info_msg_0_='%k%F{4}◤%f'
        }

        # Prompt
        PROMPT='%K{4} %B%n@%m %~ ''${vcs_info_msg_0_}%b''${NEWLINE}%K{4}  %k%F{4}◤%f '
        PS2='%K{4}  %k  '
      else
        PROMPT='%F{4}[%n@%m %~]%f''${NEWLINE}  %# '
      fi
    '';
  };
  
  users.defaultUserShell = pkgs.zsh;
}
