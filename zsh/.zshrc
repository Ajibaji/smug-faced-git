# =======================================================================================
# This file gets read when an interative shell is opened
# ———————————————————————————————————————————————————————————————————————————————————————
# load order:
# .zshenv → .zprofile → .ZSHRC → .zlogin → .zlogout
# ———————————————————————————————————————————————————————————————————————————————————————
# use this file to set everything needed for interactive usage. e.g:
#  - prompt formatting
#  - command completion
#  - output formatting
#  - user-usable aliases/functions
#  - history management
# =======================================================================================


#_____________________________________________________________________ALIASES_&_FUNCTIONS:
    source ${HOME}/.config/shell/salad-source.sh

    # ls on directory change
      function chpwd() {
        emulate -L zsh
        l
      }

#___________________________________________________________________________________SHELL:
    # ZPLUG
    export ZPLUG_HOME=${HOME}/.zplug
    export ZPLUG_REPOS=${ZPLUG_HOME}/repos
    export ZPLUG_CACHE_DIR=${ZPLUG_HOME}/cache
    export ZPLUG_BIN=${ZPLUG_HOME}/bin

    if [[ ! -d $ZPLUG_HOME ]]; then
      # curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
      git clone --depth 1 git@github.com:zplug/zplug $ZPLUG_HOME
    fi

    source $ZPLUG_HOME/init.zsh

    zplug "zplug/zplug", hook-build:'zplug --self-manage'

    zplug "mafredri/zsh-async", use:asynch.zsh, from:github, defer:0
      fpath+=("${ZPLUG_REPOS}/mafredri/zsh-async")
    zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
      fpath+=("${ZPLUG_REPOS}/sindresorhus/pure/functions")
      export PURE_PROMPT_SYMBOL="  >"
      export PURE_CMD_MAX_EXEC_TIME=1
      prompt_pure_set_title() {} # disable title updates by pure

    # zplug "larkery/zsh-histdb", from:github, at:main
    # zplug "m42e/zsh-histdb-skim", from:github, at:main

    if ! zplug check --verbose; then
      printf "Install? [y/N]: "
      if read -q; then
        echo; zplug install
      fi
    fi

    zplug load

    # Set TERM variable
    	#export TERM="xterm-256color"

    # Set bindings
    	set -o emacs 
      bindkey "^[[3~" delete-char
      bindkey -M emacs "^[[1;3C" forward-word   # bind alt-right to forward-word
      bindkey -M emacs "^[[1;3D" backward-word  # bind alt-left to backward-word
      bindkey '^R' histdb-skim-widget

    # Enable Ctrl-x-e to edit command line
      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey '^xe' edit-command-line
      bindkey '^x^e' edit-command-line

    # auto completion
      # # export ZSH_AUTOSUGGEST_MANUAL_REBIND=anything
      # zstyle ':completion:*' menu select
      # zstyle ':completion:*' completer _complete _match _approximate
      # zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      # zstyle ':completion:*' ignored-patterns '_*'
      # zstyle ':completion:*' rehash true
      # zmodload zsh/complist

      # checking cached .zcompdump file to see if it must be regenerated once a day only
      # autoload -Uz compinit 
      # setopt EXTENDEDGLOB
      # for dump in $HOME/.zcompdump(#qN.m1); do
      #   compinit
      #   if [[ -s "$dump" && (! -s "$dump.zwc" || "$dump" -nt "$dump.zwc") ]]; then
      #     zcompile "$dump"
      #   fi
      # done
      # unsetopt EXTENDEDGLOB
      # compinit -C
      # autoload -U +X bashcompinit && bashcompinit
      # complete -C '/usr/local/bin/aws_completer' aws
      # source /usr/local/etc/bash_completion.d/az

    export HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')
    # Set title to current working directory
      export DISABLE_AUTO_TITLE="true"
      precmd () {
        if [ $TERM = 'xterm-kitty' ]
        then
          kitty @ set-tab-title $(print -Pn "${PWD/${PWD%*\/*\/*}\/}\007")
        else
          print -Pn "${PWD/${PWD%*\/*\/*}\/}\007"
        fi
      }

    # shell history saved to database. searching included 
      # [[ $TERM_PROGRAM != "DTerm" ]] && eval "$(atuin init zsh)"
      # source ~/.config/zsh/.zhistory

    # Automatic node version switching (FNM)
      add-zsh-hook chpwd load-nvmrc
      load-nvmrc

    # Set directory colours (see Nord dir_colors)
      test -r ~/.dir_colors && eval $(dircolors ~/.dir_colors)

    # zsh-syntax-highlighting
      # source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# SOURCE
  # source $HOME/seeshellontheseasaw/*.zshrc

# autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /usr/local/bin/terraform terraform
