# =======================================================================================
# source this file into your ~/.*rc file to import:
#  - aliases
#  - functions
# =======================================================================================




#_________________________________________________________________________________ALIASES:
    source ${HOME}/.config/shell/lib/aliases.sh

#_______________________________________________________________________________FUNCTIONS:
    source ${HOME}/.config/shell/lib/functions.sh

#__________________________________________________________________________THEME_SWITCHER:
    source ${HOME}/.config/shell/lib/theme.sh

#_________________________________________________________________________________SECRETS:
    if [[ -d ${HOME}/seeshellontheseasaw ]]
    then
        source ${HOME}/seeshellontheseasaw/private.sh
    fi
