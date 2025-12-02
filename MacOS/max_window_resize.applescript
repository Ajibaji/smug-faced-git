#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Custom Window Size
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon images/custom-window-size.png

# Documentation:
# @raycast.author Ammar
# @raycast.authorURL https://github.com/ajibaji
# @raycast.description Resize frontmost window to fill screen without overlapping top status/menu bar (35px). A workaround for apps using MacOS' native tabs

on run

	tell application "System Events"
		set frontApp to name of first application process whose frontmost is true
	end tell

	tell application "Finder"
    get bounds of window of desktop
	end tell

	tell application "Finder"
    set desktopBounds to bounds of window of desktop
    set screenWidth to item 3 of desktopBounds
    set screenHeight to item 4 of desktopBounds
	end tell

	set theApp to frontApp
	set appWidth to "" & screenWidth
	set appHeight to "" & ( screenHeight - 35 )

	tell application frontApp to activate
	tell application "System Events" to tell application process frontApp
		try
      set position of window 1 to {0, (screenHeight - appHeight)}
			set size of window 1 to {appWidth, appHeight}
		on error errmess
			log errmess
			-- no window open
		end try
	end tell
end run
