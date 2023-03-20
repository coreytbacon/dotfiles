# Sets reasonable macOS defaults.
#
# Or, in other words, set shit how I like in macOS.
#
# The original idea (and a couple settings) were grabbed from:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.macos
#
# Run ./_set-defaults.sh and you'll be good to go.

# MAC OS .plist  Library/Preferences/.GlobalPreferences.plist



# Disable press-and-hold for keys in favor of key repeat.
defaults write -g ApplePressAndHoldEnabled -bool false

# Use AirDrop over every interface. srsly this should be a default.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

# Always open everything in Finder's list view. This is important.
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# Show the ~/Library folder.
chflags nohidden ~/Library

# Set a really fast key repeat.
# defaults write NSGlobalDomain KeyRepeat -int 45
# Set the Finder prefs for showing a few different volumes on the Desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Run the screensaver if we're in the bottom-left hot corner.
defaults write com.apple.dock wvous-bl-corner -int 1000
defaults write com.apple.dock wvous-bl-modifier -int 0

# Hide Safari's bookmark bar.
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Set up Safari for development.
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true


# Stop Full Names from Copying with Email Addresses in Mac OS X Mail
# defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Enable Text Selection in Quick Look Windows
defaults write com.apple.finder QLEnableTextSelection -bool TRUE;killall Finder

# Always Show Hidden Files in the Finder
defaults write com.apple.finder AppleShowAllFiles -bool YES && killall Finder

# Hide Desktop Icons Completely
defaults write com.apple.finder CreateDesktop -bool false && killall Finder

# Show System Info at the Login Screen
# ENABLE: sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
# DISABLE: sudo defaults delete /Library/Preferences/com.apple.loginwindow AdminHostInfo

### SCREEN SHOTS

# Change Where Screen Shots Are Saved To
# defaults write com.apple.screencapture location ~/Pictures/Screenshots

# Change the Default Screen Shot Image Type
# defaults write com.apple.screencapture type jpg && killall SystemUIServer

### LAUNCHPAD

# Change ‘10’ into the number of icons to be showed in a single column
defaults write com.apple.dock springboard-columns -int 12

# Change ‘10’ into the number of icons to be showed in a single row
defaults write com.apple.dock springboard-rows -int 8

# Restart to enable changes
defaults write com.apple.dock ResetLaunchPad -bool TRUE;killall Dock

# Revert to default
# defaults delete com.apple.dock springboard-rows
# defaults delete com.apple.dock springboard-columns
# defaults write com.apple.dock ResetLaunchPad -bool TRUE;killall Dock

### FINDER

# You can enable a the quit option by entering the following command in Terminal:
defaults write com.apple.finder QuitMenuItem -bool true; killall Finder

# Revert to default
# defaults write com.apple.finder QuitMenuItem -bool false; killall Finder

# File extensions (.jpg, .txt, .pdf, etc) are normally hidden by default in OS X.
# You can either set all extensions to be displayed through the following command:
defaults write NSGlobalDomain AppleShowAllExtensions -bool true; killall Finder

# Revert to default
# defaults write NSGlobalDomain AppleShowAllExtensions -bool false; killall Finder

### UI

# Disable animations when opening and closing windows.
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Disable animations when opening a Quick Look window.
defaults write -g QLPanelAnimationDuration -float 0

# Accelerated playback when adjusting the window size (Cocoa applications).
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Disable animation when opening the Info window in Finder (cmd⌘ + i).
defaults write com.apple.finder DisableAllAnimations -bool true

# Disable animations when you open an application from the Dock.
defaults write com.apple.dock launchanim -bool false

# Remove/Disable the Auto-Hide Dock Delay
# defaults write com.apple.Dock autohide-delay -float 0 && killall Dock

# Speed Up Mission Control Animations / Make all animations faster that are used by Mission Control.
defaults write com.apple.dock expose-animation-duration -float 0.1 && killall Dock

# Make Hidden App Icons Translucent in the Dock
defaults write com.apple.Dock showhidden -bool YES && killall Dock







