# if not running interactively, do nothing
[ -z "$PS1" ] && return

#________________________________________________________________________________ENV_VARS:
  source ${HOME}/.config/shell/env.sh

#_____________________________________________________ALIASES,_FUNCTIONS_&_THEME_SWITCHER:
  source ${HOME}/.config/shell/salad-source.sh

#__________________________________________________________________________________PROMPT:
  prompt_symbol="❯"
  prompt_clean_symbol="☀ "
  prompt_dirty_symbol="☂ "
  prompt_venv_symbol="☁ "

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
        git_prompt=" $RED$prompt_dirty_symbol$branch$NOCOLOR"
      else
        git_prompt=" $NOCOLOR$prompt_clean_symbol$branch$NOCOLOR"
      fi
    fi

    local venv_prompt=
    if [ -n "$VIRTUAL_ENV" ]; then
      venv_prompt=" $BLUE$prompt_venv_symbol$(basename $VIRTUAL_ENV)$NOCOLOR"
    fi

    local host_prompt=
    [ -n "$remote" ] && host_prompt="@$YELLOW$HOSTNAME$NOCOLOR:"

    first_line="$GREEN\w$NOCOLOR$git_prompt$venv_prompt"
    second_line="\`if [ \$? = 0 ]; then echo \[\$CYAN\]; else echo \[\$RED\]; fi\`\$prompt_symbol\[\$NOCOLOR\] "
    PS1="\n$first_line\n    $second_line"
    PS2="\[$CYAN\]$prompt_symbol\[$NOCOLOR\] "

    local title="$(basename "$PWD")"
    [ -n "$remote" ] && title="$title \xE2\x80\x94 $HOSTNAME"
    echo -ne "\033]0;$title"; echo -ne "\007"
  }

  command -v git >/dev/null 2>&1 && PROMPT_COMMAND=prompt_command

#_____________________________________________________________________________________RUN:

  if [[ "$PWD" == "/mnt/"* ]]; then
    cd ~
  fi

# fnm
FNM_PATH="${HOME}/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi
