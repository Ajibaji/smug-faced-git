# =======================================================================================
# source this file into your ~/.*rc file to import:
#  - aliases
#  - functions
# =======================================================================================




#_________________________________________________________________________________ALIASES:
    source "$HOME/.config/shell/lib/aliases.sh"

#_______________________________________________________________________________FUNCTIONS:
    source "$HOME/.config/shell/lib/functions.sh"

#__________________________________________________________________________THEME_SWITCHER:
    source "$HOME/.config/shell/lib/theme.sh"

#_________________________________________________________________________________SECRETS:
# this references content pulled from a private repo. it is not nor has it ever been in
# this one
    if [[ -d ${HOME}/seeshellontheseasaw ]]
    then
        source ${HOME}/seeshellontheseasaw/private.sh
    fi
