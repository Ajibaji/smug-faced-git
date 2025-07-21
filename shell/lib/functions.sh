# =======================================================================================
# This file contains shell agnostic functions for sourcing into a shell's .*rc file
# =======================================================================================

# MAC ONLY FUNCTIONS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # cd to the path of the front Finder window
      cdf() {
        target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
        if [ "$target" != "" ]; then
          cd "$target"; pwd
        else
          echo 'No Finder window found' >&2
        fi
      }

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

    # DTERM
      if [[ $TERM_PROGRAM = "DTerm" && -x /usr/libexec/path_helper ]]
      then
          eval `/usr/libexec/path_helper -s`
      fi

    # PERL
      # eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
fi

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
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  MAGENTA="$(tput setaf 5)"
  CYAN="$(tput setaf 6)"
  WHITE="$(tput setaf 7)"
  GRAY="$(tput setaf 8)"
  BOLD="$(tput bold)"
  UNDERLINE="$(tput sgr 0 1)"
  INVERT="$(tput sgr 1 0)"
  NOCOLOR="$(tput sgr0)"

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

# KUBERNETES
  # list all resources
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

  # remove namespace
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

  # remove remove all namespace
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
          # consider replacing with fd -g '{dir,*anotherDir,*.tmp,*.zip,*.spec.*,*test*}' | xargs rm -rf -v
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

# SHOW $PATH ENTRIES CLEARLY
  function pathls () {
    echo $PATH | tr ":" "\n"
  }

# SHOW WHICH PATH ENTRIES AN EXECUTABLE APPEARS IN
  function whichpath () {
    if [ $# -eq 0 ]
    then
      >&2 echo 'Error: Missing parameter'
      echo ''
      echo 'Show which $PATH entry an executable appears in ("/mnt/" entries are skipped).'
      echo '    Example: "whichpath git"'
      return 1
    fi

    pathls | while read line
    do
      if [[ "$line" != "/mnt/"* && -d $line ]]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
          gfind $line -maxdepth 1 -name $@ -type f,l -exec echo $line \;
        else
          find $line -maxdepth 1 -name $@ -type f,l -exec echo $line \;
        fi
      fi
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

# FIND IN FILES
  function fif () {
    rg  \
      --column \
      --no-heading \
      --fixed-strings \
      --ignore-case \
      --hidden \
      --follow \
      --no-ignore \
      --glob '!.git/*' "$1" \
    | awk -F  ":" '/1/ {start = $2<5 ? 0 : $2 - 5; end = $2 + 5; print $1 " " $2 " " $3 " " start ":" end}' \
    | fzf \
        --bind 'ctrl-o:execute(nvim +"call cursor({2},{3})" {1})+cancel' \
        --preview 'bat --wrap character --color always {1} --highlight-line {2} --line-range {4}' \
        --preview-window wrap
  }

  function ff () {
    rm -f /tmp/rg-fzf-{r,f}
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case --no-ignore"
    INITIAL_QUERY="${*:-}"
    fzf --ansi --disabled --query "$INITIAL_QUERY" \
        --bind "start:reload:$RG_PREFIX {q}" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ ripgrep ]] &&
          echo "rebind(change)+change-prompt(1. ripgrep> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||
          echo "unbind(change)+change-prompt(2. fzf> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"' \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --prompt '1. ripgrep> ' \
        --delimiter : \
        --header 'CTRL-T: Switch between ripgrep/fzf' \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(nvim {1} +"call cursor("{2}", "{3}")")'
  }

function gg () {
  fd ${*:-} --no-ignore |
    fzf --prompt 'Files> ' \
        --header 'CTRL-T: Switch between Files/Directories' \
        --bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ Files ]] &&
                echo "change-prompt(Files> )+reload(fd ${*:-})" ||
                echo "change-prompt(Directories> )+reload(fd --type directory)"' \
        --preview '[[ $FZF_PROMPT =~ Files ]] && bat --color=always {} || tree -C {}'
}

# Automatic node version switching (FNM)
  function load-nvmrc() {
    if [[ -f .nvmrc && -r .nvmrc ]]
    then
      fnm use
    else
      fnm use default > /dev/null 2>&1
    fi
  }

# YAZI
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(\cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
