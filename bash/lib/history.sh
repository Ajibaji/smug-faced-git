#!/bin/bash

export HISTDB="$HOME/.dbhist"

__quote_str() {
	local str
	local quoted
	str="$1"
	quoted="'$(echo "$str" | sed -e "s/'/''/g")'"
	echo "$quoted"
}

__create_histdb() {
	sqlite3 "$HISTDB" <<-EOD
	CREATE TABLE command (
		command_id INTEGER PRIMARY KEY,
		shell TEXT,
		command TEXT,
		cwd TEXT,
		return INTEGER,
		started INTEGER,
		ended INTEGER
	);
	EOD
}

precmd_bash_history_sqlite() {
  if [[ "$(builtin history -a /dev/stdout | wc -l)" != "0" ]]; then
	  sqlite3 "$HISTDB" <<-EOD
	  	INSERT INTO command (shell, command, cwd, started, ended, return)
	  	VALUES (
	  		'bash',
	  		$(__quote_str "$LAST_COMMAND"),
	  		$(__quote_str "$PWD"),
	  		$START_TIME,
        $END_TIME,
        $LAST_COMMAND_EXIT_CODE
	  	);
		EOD
  fi
}

shell_history_search() {
  local separator='   '
  [[ "$CURRENT_THEME" = "DARK" ]] && local column_colour=0
  local id_column_colour=${column_colour:-7}
  local sql_query="SELECT printf(\"%c[3%dm%s%c[0m\", char(27), $id_column_colour, command_id, char(27)), command FROM command"
  local SQL_CMD="sqlite3 -ascii -separator '$separator' $HISTDB '$sql_query WHERE command LIKE "
  local order_by="ORDER BY command_id desc"
  local ascii_format="tr '\036' '\000'"
  selected=$(sqlite3 $HISTDB \
    -ascii -separator "$separator" \
    "$sql_query $order_by;" | \
    $ascii_format | \
    fzf \
      --read0 --disabled --wrap-sign='' --gap \
      --bind "change:reload:$SQL_CMD\"%{q}%\" $order_by' | $ascii_format" \
      --preview-window 'bottom,10,wrap' \
      --preview "sqlite3 \
        -line \
        $HISTDB \
        'SELECT
           cwd as dir,
           datetime(started, \"unixepoch\") as date,
           (ended - started) as time_taken,
           return as exit_code,
           command 
         FROM command
         WHERE command_id=\"{1}\"'" | \
    cut -f 2- -d ' ' | \
    sed 's/^[[:space:]]*//'
  )
  READLINE_LINE="$selected"
  READLINE_POINT=${#selected}
}

if [[ ! -f ${HISTDB} ]]; then
  __create_histdb
fi

PROMPT_COMMAND+=(precmd_bash_history_sqlite)
