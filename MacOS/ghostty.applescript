tell application "Ghostty"
    set allTerms to terminals

    repeat with t in allTerms
        set title to name of t
        if {title starts with "/" or title start with "~"} then
            input text "get-current-theme" to t
            send key "enter" to t
        end if
    end repeat
end tell
