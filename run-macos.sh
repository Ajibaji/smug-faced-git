#!/usr/bin/env bash

# install dotbot dependencies and add required apt repositories

function printHeading() {
  printf "\n\n\n\n%119s\n\n" ${@}— | sed -e 's/ /—/g';
}

printHeading 'CONFIGURING-MACOS'

# TWM
defaults write com.apple.dock workspaces-auto-swoosh -bool NO
killall Dock
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

# set XDG_CONFIG_HOME
launchctl setenv XDG_CONFIG_HOME "$HOME/.config"

# set default editor
defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers \
  -array-add '{LSHandlerContentType=public.plain-text;LSHandlerRoleAll=dev.zed.Zed;}'

# ctrl + cmd to drag windows
defaults write -g NSWindowShouldDragOnGesture -bool true

# mission control fix for aerospace
defaults write com.apple.dock expose-group-apps -bool true && killall Dock

# disable displays have separate spaces
defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer

# Keyboard: Set a shorter Delay until key repeat
defaults write -g InitialKeyRepeat -int 15

# Keyboard: Set a fast keyboard repeat rate
defaults write -g KeyRepeat -int 2

# Finder: Show all extenions
defaults write -g AppleShowAllExtensions -bool true

# Finder: Show ~/Library in finder
chflags nohidden ~/Library

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -int 1
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
defaults write -g com.apple.mouse.tapBehavior -int 1

# Trackpad: three finger drag
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# Global: Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write -g AppleKeyboardUIMode -int 3

# Finder: Full POSIX path in finder windows
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Finder: Show Status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: new windows start at home directory
defaults write com.apple.finder NewWindowTarget -string PfHm
defaults write com.apple.finder NewWindowTargetPath -string "file:///$HOME"

# Finder: only search the current direcotry
defaults write com.apple.finder FXDefaultSearchScope -string SCcf

# Mission Control: Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Dock: Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Dock: Disable recents
defaults write com.apple.dock show-recents -bool false

# Screenshot: Save screenshots with date in filename
defaults write com.apple.screencapture include-date -bool true

# Bottom right screen corner → Notes
defaults write com.apple.dock wvous-br-corner -int 14


if ! command -v brew > /dev/null 2>&1; then
  printHeading 'FOT-BREW'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if command -v brew > /dev/null 2>&1; then
  printHeading 'MASHING-A-BREW'
  brew bundle
fi
