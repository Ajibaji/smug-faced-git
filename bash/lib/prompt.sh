# =======================================================================================
# source this file into your ~/.*rc file to import:
#  - custom prompt definition
# =======================================================================================

prompt_symbol='    $_'
prompt_venv_symbol="☁ "
large_font_prefix=""
large_font_suffix=""
medium_font_prefix=""
medium_font_suffix=""

function cmd_running_time() {
  REPLY=''
  if [[ "$(builtin history -a /dev/stdout | wc -l)" != "0" ]]; then
    export START_TIME=$(HISTTIMEFORMAT='%s ' builtin history 1 | cut -f5 -d' ')
    export END_TIME=$(date +%s)
    local running_time=$((END_TIME - START_TIME))
    if [[ $running_time -gt 0 ]]; then
      running_time_formatted="$((($running_time / 60) / 60)):$((($running_time / 60) % 60)):$(($running_time % 60))"
      REPLY="[$running_time_formatted]"
    fi
  fi
}

function print_running_time() {
  printf "$GRAY%$(($COLUMNS - 11))s\e[3m${| cmd_running_time;}\e[0m\n"
}

function prompt_command() {
  local remote=
  [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] && remote=1

  local git_prompt=
  if [[ "true" = "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]]; then
    local branch="$(git symbolic-ref HEAD 2>/dev/null)"
    branch="${branch##refs/heads/}"

    local dirty=
    git diff --no-ext-diff --quiet --exit-code --ignore-submodules 2>/dev/null || dirty=1
    [ -z "$dirty" ] && test -n "$(git status --porcelain)" && dirty=1

    if [ -n "$dirty" ]; then
      git_prompt="  $RED$medium_font_prefix[$branch]$medium_font_suffix$NOCOLOR"
    else
      git_prompt="  $NOCOLOR$medium_font_prefix[$branch]$medium_font_suffix"
    fi
  fi

  local venv_prompt=
  if [ -n "$VIRTUAL_ENV" ]; then
    venv_prompt=" \[$BLUE\]$medium_font_prefix$prompt_venv_symbol$(basename $VIRTUAL_ENV)$medium_font_suffix\[$NOCOLOR\]"
  fi

  local host_prompt=
  [ -n "$remote" ] && host_prompt="@$YELLOW$HOSTNAME$NOCOLOR:"

  second_line="\[\`if [ \$? = 0 ]; then echo \$CYAN\$BOLD; else echo \$RED\$BOLD; fi\`\]\$prompt_symbol\[\$NOCOLOR\] "

  w='\w'
  current_dir=${w@P}
  current_dir="$large_font_prefix${w@P}$large_font_suffix"
  first_line="${|print_running_time;}$CYAN$current_dir$NOCOLOR$git_prompt$venv_prompt\n"
  echo -e "$first_line"
  PS1="$second_line"

  local title="$(basename "$PWD")"
  [ -n "$remote" ] && title="$title \xE2\x80\x94 $HOSTNAME"
  printf "\033]0;$title\007"
}

set_last_command() {
  export LAST_COMMAND_EXIT_CODE=$?
  local last_command
  last_command=$(LC_ALL=C HISTTIMEFORMAT='' builtin history 1)
  last_command="${last_command#*[[:digit:]][* ] }"
  export LAST_COMMAND="$last_command"
}

PROMPT_COMMAND+=(set_last_command)

declare -a precmd_functions

ls_on_cd() {
  if [[ "$(builtin history -a /dev/stdout | wc -l)" != "0" ]] && [[ "$LAST_COMMAND" == *"cd "* ]]; then
    l
  fi
}

precmd_functions+=(ls_on_cd)

for precmd_function in "${precmd_functions[@]:-}"; do
  PROMPT_COMMAND+=("$precmd_function")
done

PROMPT_COMMAND+=(prompt_command)
