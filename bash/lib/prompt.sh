# =======================================================================================
# source this file into your ~/.*rc file to import:
#  - custom prompt definition
# =======================================================================================
prompt_symbol="❯"
prompt_clean_symbol="☀ "
prompt_dirty_symbol="☂ "
prompt_venv_symbol="☁ "

function cmd_running_time() {
  REPLY=''
  if [[ "$(builtin history -a /dev/stdout | wc -l)" != "0" ]]; then
    export START_TIME=$(HISTTIMEFORMAT='%s ' builtin history 1 | cut -f5 -d' ')
    export END_TIME=$(date +%s)
    local running_time=$[END_TIME-START_TIME]
    if [[ $running_time -gt 0 ]]; then
      running_time_formatted="$((($running_time/60)/60)):$((($running_time/60)%60)):$(($running_time%60))"
      REPLY="[$running_time_formatted]"
    fi
  fi
}

function print_running_time() {
  printf "$GRAY%$[$COLUMNS-11]s\e[3m${|cmd_running_time;}\e[0m\n"
}

function prompt_command() {
  local remote=
  [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] && remote=1

  local git_prompt=
  if [[ "true" = "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]]; then
    local branch="$(git symbolic-ref HEAD 2>/dev/null)"
    branch="${branch##refs/heads/}"

    local dirty=
    # Modified files
    git diff --no-ext-diff --quiet --exit-code --ignore-submodules 2>/dev/null || dirty=1
    # Untracked files
    [ -z "$dirty" ] && test -n "$(git status --porcelain)" && dirty=1

    if [ -n "$dirty" ]; then
      git_prompt=" $RED$prompt_dirty_symbol$NOCOLOR$branch"
    else
      git_prompt=" $YELLOW$prompt_clean_symbol$NOCOLOR$branch"
    fi
  fi

  local venv_prompt=
  if [ -n "$VIRTUAL_ENV" ]; then
    venv_prompt=" $BLUE$prompt_venv_symbol$(basename $VIRTUAL_ENV)$NOCOLOR"
  fi

  local host_prompt=
  [ -n "$remote" ] && host_prompt="@$YELLOW$HOSTNAME$NOCOLOR:"

  first_line="${|print_running_time;}$CYAN\w$NOCOLOR$git_prompt$venv_prompt"
  second_line="\`if [ \$? = 0 ]; then echo \[\$CYAN\]; else echo \[\$RED\]; fi\`\$prompt_symbol\[\$NOCOLOR\] "
  PS1="\n$first_line\n    $second_line"
  PS2="\[$CYAN\]$prompt_symbol\[$NOCOLOR\] "

  local title="$(basename "$PWD")"
  [ -n "$remote" ] && title="$title \xE2\x80\x94 $HOSTNAME"
  echo -ne "\033]0;$title"; echo -ne "\007"
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
