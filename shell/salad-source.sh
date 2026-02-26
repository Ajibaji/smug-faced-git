# =======================================================================================
# source this file into your ~/.*rc file to import:
#  - aliases
#  - functions
#  - theme-switcher
#  - private-repo files
# =======================================================================================


#_________________________________________________________________________________ALIASES:
    source "$HOME/.config/shell/lib/aliases.sh"


#_______________________________________________________________________________FUNCTIONS:
    source "$HOME/.config/shell/lib/theme.sh"


#__________________________________________________________________________THEME_SWITCHER:
    source "$HOME/.config/shell/lib/functions.sh"


#_________________________________________________________________________________SECRETS:
# this references content pulled from a private repo. it is not nor has it ever been in
# this one
    if [[ -d $HOME/seeshellontheseasaw ]]
    then
        source $HOME/seeshellontheseasaw/private.sh
    fi
