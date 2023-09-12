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



#_________________________________________________________________________________ALIASES:
    # AWS SET ENV VARS
      function aws-env () {
        local ROLE=$@
        [[ $SILENT != "true" ]] && echo $ROLE
        PROFILE=${ROLE:-WS-00YY-role_DEVOPS}
        [[ $SILENT != "true" ]] && echo "Writing $PROFILE environment variables";
        export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id --profile "$PROFILE");
        export AWS_DEFAULT_REGION=$(aws configure get region --profile "$PROFILE");
        export AWS_DEPLOY_PROFILE=$PROFILE
        export AWS_PROFILE=$PROFILE
        export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key --profile "$PROFILE");
        export AWS_SESSION_TOKEN=$(aws configure get aws_session_token --profile "$PROFILE");
        [[ $SILENT != "true" ]] && echo "$PROFILE environment variables exported";
        [[ $SILENT != "true" ]] && echo "AWS_PROFILE=${PROFILE}"
      }

    # BAT ALIASES
      alias cat='bat --paging=never'

    # DOCKER ALIASES
      # alias docker='lima nerctl'
      alias dokcer='docker $@'
      alias dockre='docker $@'
      alias dokcre='docker $@'

    # DOS-style clear-screen
      alias cls='clear'

    # GIT ALIASES
      alias gst='git status'
      alias gco='git checkout $@'

    # KUBERNETES ALIASES
      alias kk='kubectl $@'

    # LAZY-GIT/GITUI
      alias lg="lazygit"
      # alias lg="gitui -t ${CURRENT_THEME}-theme.ron"

    # NEOVIM
      alias v='nvim'
      alias vim='v'

    # NEOVIDE (simlink serves unmanagable OS window...this is the workaround)
      # alias neovide='/Applications/Neovide.app/Contents/MacOS/neovide'

    # TOGGLE-THEME
      alias tt='toggle-theme'

    # WHIPTAIL
      # alias whiptail='dialog'

#_______________________________________________________________________________FUNCTIONS:
    # cd to the path of the front Finder window
      cdf() {
        target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
        if [ "$target" != "" ]; then
          cd "$target"; pwd
        else
          echo 'No Finder window found' >&2
        fi
      }

    # fix tabs (mixed tabs and spaces error in eslint)
      function fixtabs () {
        find . -name '*.ts' ! -type d -exec bash -c 'expand -t 4 "$0" > /tmp/e && mv /tmp/e "$0"' {} \;
      }

    # text formatting
      ansi()          { echo -e "\e[${1}m${*:2}\e[0m"; }
      bold()          { ansi 1 "$@"; }
      italic()        { ansi 3 "$@"; }
      underline()     { ansi 4 "$@"; }
      strikethrough() { ansi 9 "$@"; }
      red()           { ansi 31 "$@"; }

      function printHeader () {
        printf "%${COLUMNS}s\n" `italic $@`— | sed -e 's/ /—/g'
      }

    # ls++ ordered, seperated and coloured
      function l () {
        args=$@
        headers="Permissions     Owner         Group    Size     Modified  Name"
        echo 
        printHeader DIRECTORIES
        echo "$headers"
        echo "$(ls -lah $args | grep '^d' | sort -f -k 9)"
        echo 
        printHeader FILES
        echo "$headers"
        filesList=$(ls -lah $args | grep -v '^d' | grep -v '^t' | sort -f -k 9) 
        echo "$filesList"
        echo
      }

    # ls on directory change
      function chpwd() {
        emulate -L zsh
        l
      }

    # KUBERNETES
      function kkgetall () {
        if [ $@ = '' ]
        then
          echo 'missing parameter'
          return 1
        fi
        for resource in $(kubectl api-resources --namespaced=true -o name --verbs=get)
        do
          if [ ! $resource = 'events.events.k8s.io' ]
          then
            kubectl get $resource -n "$@" --ignore-not-found=true --show-kind=true
          fi
        done
      }

      function kkrmns () {
        if [ $@ = '' ]
        then
          echo 'missing parameter'
          return 1
        fi
        local PARAMS=$@
        kubectl delete job,deploy,svc,hpa --all -n $PARAMS
        kubectl delete pvc -n $PARAMS 
        kubectl delete ns $PARAMS
      }

      function kkrmnsall () {
        for namespace in $(kk get ns | grep "pr---" | awk '{ print $1 }')
        do
          kkrmns $namespace &
        done
      }

    # REMOVE ALL NODE_MODULES DIRS
      function  rmm() {
        local dir_names=($@)
        case $dir_names in
          node_modules)
            if whiptail --yesno "Delete all $( echo $dir_names) directories from this tree?" 20 60
            then
              echo "Deleting all 'node_modules' directories from this tree..."
              find . -name $dir_names -type d -prune -exec rm -rf '{}' +
              echo "Done"
            fi
            ;;
          *)
            if [[ $dir_names ]]
            then
              local answer=$(whiptail --title "Delete matching subdirectories" --radiolist \
                "Include subdirectories in node_modules?" 20 78 2 \
                "EXCLUDE" "" ON\
                "INCLUDE" "" OFF 3>&1 1>&2 2>&3)
              if [[ $? == "0" ]]
              then
                [[ $answer == "EXCLUDE" ]] && local exclude=*/node_modules/*
                for directory in $dir_names
                do
                  echo "Deleting all '$directory' directories from this tree..."
                  (find . -name $directory -type d -not -path "$exclude" -exec rm -rf '{}' + &)
                done
                wait
                echo "Done"
              else
                echo "Cancelled"
              fi
            else
              echo "No directory parameters passed"
            fi
            ;;
        esac
      }

    #function jeff () {
    #	DISTROS=$(whiptail --title "Delete directories" --checklist "Choose which directories to remove from this tree:" 15 60 4 "-or -name \"node_modules\"" "node_modules" ON "-or -name \"dist\"" "dist" OFF "-or -name \"built\"" "built" OFF "-or -name \"build\"" "build" OFF 3>&1 1>&2 2>&3)
    #	DISTROS=$(whiptail --title "Delete directories" --checklist "Choose which directories to remove from this tree:" 15 60 4 node_modules '' ON dist '' OFF built '' OFF build '' OFF 3>&1 1>&2 2>&3)
    #	echo "result: $DISTROS"
    #	exitstatus=$?
    #	if [ $exitstatus = 0 ]; then
    #		find . \( -name "itsNeverGoingToFindAFileWithThisNameIsIt" $DISTROS\) -type d -prune
    #	else
    #	    echo "Nope."
    #	fi
    #}

    # RUBY
      source /usr/local/opt/chruby/share/chruby/chruby.sh
      source /usr/local/opt/chruby/share/chruby/auto.sh
      chruby ruby-3.1.0 # set default ruby version. Use 'chruby system' to use MacOS version

    # RUST
      source $HOME/.cargo/env

    # PERL
      eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"

    # MOVE TO OTHER SCREENS
        # function screen-left () {
        #     osascript -e 'tell application "System Events" to keystroke key code 123 using {control down, shift down}'
        # }
        #
        # function screen-centre () {
        #     osascript -e 'tell application "System Events" to keystroke key code 126 using {control down, shift down}'
        # }
        #
        # function screen-down () {
        #     osascript -e 'tell application "System Events" to keystroke key code 125 using {control down, shift down}'
        # }
        #
        # function screen-max () {
        #     osascript -e 'tell application "System Events" to keystroke key code 36 using {control down, option down}'
        # }

    # SHOW PATH ENTRIES CLEARLY
      function pathls () {
        echo $PATH | tr ":" "\n"
      }

    # SHOW WHICH PATH ENTRIES AN EXECUTABLE APPEARS IN
      function whichpath () {
        if [ $@ = '' ]
        then
          echo 'missing parameter'
          return 1
        fi

        for directory in $(pathls)
        do
          gfind $directory -maxdepth 1 -name $@ -type f,l -exec echo $directory \;
        done
      }

    # SOCKS PROXY
      function socks () {
        case "$@" in
          on) export http_proxy="socks5://127.0.0.1:1234" && echo "PROXY set. Make sure it's enabled in network settings";;
          off) unset http_proxy && echo "PROXY unset";;
          *) echo "Missing parameter. Use 'on' | 'off'";;
        esac
      }

    # SPOTIFY_TUI
    #  function spt () {
    #    TERM=xterm-256color spotify-tui
    #  }

    # STARTUP
      # function oneTui () {
      #   screen-down
      #   sleep 1
      #   screen-max
      #   btm
      # }
      #
      # function twoTui () {
      #   screen-left
      #   screen-max
      # }

    # SCRCPY (clone android screen)
      function phone () {
        scrcpy $@
      }

    # LAZY-GIT (cd into slected repo)
      function lg () {
        export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir
        lazygit "$@"
        if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
          cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
          rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
        fi
      }


# SHELL:
    # Set TERM variable
    	#export TERM="xterm-256color"

    # DTERM
      if [[ $TERM_PROGRAM = "DTerm" && -x /usr/libexec/path_helper ]]
      then 
          eval `/usr/libexec/path_helper -s`
      fi

    # Set bindings
    	set -o emacs 
      bindkey "^[[3~" delete-char
      bindkey -M emacs "^[[1;3C" forward-word   # bind alt-right to forward-word
      bindkey -M emacs "^[[1;3D" backward-word  # bind alt-left to backward-word

    # Enable Ctrl-x-e to edit command line
      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey '^xe' edit-command-line
      bindkey '^x^e' edit-command-line

    # prompt formatting
      autoload -Uz promptinit
      promptinit
      export PURE_PROMPT_SYMBOL="  >"
      export PURE_CMD_MAX_EXEC_TIME=1
      prompt pure
      prompt_pure_set_title() {} # disable title updates by pure

    # auto completion
      # export ZSH_AUTOSUGGEST_MANUAL_REBIND=anything
      zstyle ':completion:*' menu select
      zstyle ':completion:*' completer _complete _match _approximate
      zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' ignored-patterns '_*'
      zstyle ':completion:*' rehash true
      zmodload zsh/complist

      # checking cached .zcompdump file to see if it must be regenerated once a day only
      autoload -Uz compinit 
      setopt EXTENDEDGLOB
      for dump in $HOME/.zcompdump(#qN.m1); do
        compinit
        if [[ -s "$dump" && (! -s "$dump.zwc" || "$dump" -nt "$dump.zwc") ]]; then
          zcompile "$dump"
        fi
      done
      unsetopt EXTENDEDGLOB
      compinit -C
      autoload -U +X bashcompinit && bashcompinit
      complete -C '/usr/local/bin/aws_completer' aws
      source /usr/local/etc/bash_completion.d/az

    export HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')
    export ZPLUG_HOME=/usr/local/opt/zplug
    source $ZPLUG_HOME/init.zsh
    zplug "larkery/zsh-histdb", from:github, at:main
    zplug "m42e/zsh-histdb-skim", from:github, at:main

    if ! zplug check --verbose; then
      printf "Install? [y/N]: "
      if read -q; then
        echo; zplug install
      fi
    fi

    if zplug list > /dev/null 2>&1
    then
      zplug load
    fi
    bindkey '^R' histdb-skim-widget

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
      function load-nvmrc() {
        if [[ -f .nvmrc && -r .nvmrc ]]
        then
          fnm use
        else
          fnm use default > /dev/null 2>&1
        fi
      }
      add-zsh-hook chpwd load-nvmrc
      load-nvmrc

    # Set directory colours (see Nord dir_colors)
      test -r ~/.dir_colors && eval $(dircolors ~/.dir_colors)

    # zsh-syntax-highlighting
      source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# THEME SWITCHER
  function set-kitty-theme () {
    kitty +kitten themes --reload-in=all --config-file-name=themes.conf "$KITTY_THEME"
  }

  function set-git-theme () {
    git config --global delta.features "$CURRENT_THEME"
  }

  function set-session-theme () {
    if [[ "$CURRENT_THEME" = "DARK" ]]
    then
      gsed -i 's/LIGHT/DARK/gI' ${HOME}/.config/zsh/.zshenv_colours
    else
      gsed -i 's/DARK/LIGHT/gI' ${HOME}/.config/zsh/.zshenv_colours
    fi
    source ${HOME}/.config/zsh/.zshenv_colours
  }

  function get-current-theme () {
    defaults read -g AppleInterfaceStyle > /dev/null 2>&1
    if [[ "$?" = "0" ]]
    then
      export CURRENT_THEME=DARK
    else
      export CURRENT_THEME=LIGHT
    fi
    set-session-theme
    set-git-theme
    # set-kitty-theme
  }

  function set-os-theme () {
    osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = $@"
  }

  function toggle-theme () {
    get-current-theme
    if [[ "$CURRENT_THEME" = "DARK" ]]
    then
      darkMode="false"
      export CURRENT_THEME=LIGHT
    else
      darkMode="true"
      export CURRENT_THEME=DARK
    fi
    (set-os-theme $darkMode)
    set-session-theme
    set-kitty-theme
    set-git-theme
    # wait
  }

# SOURCE
  source $HOME/seeshellontheseasaw/*.zshrc

# RUN
  # SILENT=true aws-env & --------------- takes way too long using aws config and cant be thrown to background as env vars dont get set
  get-current-theme
  set-kitty-theme

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
