# Sets shit how I like in macOS.
#
# To find other settings:
#   $ defaults read > a
# Then change the setting:
#   $ defaults read > b
#   $ diff a b
#
# Another option is inspecting file changes in real time:
#   $ sudo opensnoop -n cfprefsd
#
# The original idea (and a couple settings) were grabbed from:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.osx

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# -----------------------------------------------------------------------------
# General & UI/UX
# -----------------------------------------------------------------------------

# Set computer name (as done via System Preferences → Sharing)
#sudo scutil --set ComputerName "OmeBook"
#sudo scutil --set HostName "OmeBook"
#sudo scutil --set LocalHostName "OmeBook"
#sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "OmeBook"

# Set sleep delay on charger (-c) and on battery (-b) in minutes
sudo pmset -c sleep 30
sudo pmset -b sleep 10

# Set display sleep delay in minutes
sudo pmset -c displaysleep 10
sudo pmset -b displaysleep 2

# Slightly dim the display when on battery
sudo pmset -b lessbright 1

# Menu bar: hide unwanted icons
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
  defaults write "${domain}" dontAutoLoad -array \
    "/System/Library/CoreServices/Menu Extras/TextInput.menu" \
    "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
    "/System/Library/CoreServices/Menu Extras/Volume.menu" \
    "/System/Library/CoreServices/Menu Extras/User.menu"
done

# Menu bar: always show these icons
defaults write com.apple.systemuiserver menuExtras -array \
  "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
  "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
  "/System/Library/CoreServices/Menu Extras/Battery.menu" \
  "/System/Library/CoreServices/Menu Extras/Clock.menu"

# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Show scrollbars only when scrolling
# Possible values: `WhenScrolling`, `Automatic` and `Always`
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable "Resume" (automatic re-open) for native apps
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable/enable the crash reporter
# defaults write com.apple.CrashReporter DialogType -string "none"
defaults write com.apple.CrashReporter DialogType -string "crashreport"

# Disable smart quotes and dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Hide guest/other account
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWOTHERUSERS_MANAGED -bool false

# Disable autorun
defaults write com.apple.digihub com.apple.digihub.blank.cd.appeared -dict action 1
defaults write com.apple.digihub com.apple.digihub.cd.music.appeared -dict action 1
defaults write com.apple.digihub com.apple.digihub.cd.picture.appeared -dict action 1
defaults write com.apple.digihub com.apple.digihub.blank.dvd.appeared -dict action 1
defaults write com.apple.digihub com.apple.digihub.dvd.video.appeared -dict action 1


# -----------------------------------------------------------------------------
# Screen
# -----------------------------------------------------------------------------

# Automatically adjust brightness
sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Display Enabled" -bool true

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 5

# Configure Night Shift
# Hot config reload:
#   sudo killall cfprefsd
#   sudo killall corebrightnessd
currentUserUID=$(dscl . -read /Users/"$(whoami)"/ GeneratedUID) # Get the GeneratedUID for the current user
currentUserUID=$(echo $currentUserUID | cut -d' ' -f2) # Remove the "GeneratedUID: " part
currentUserUID="CBUser-"$currentUserUID # Append the prefix
sudo /usr/libexec/PlistBuddy -c "Set :${currentUserUID}:CBBlueReductionStatus:BlueReductionEnabled 1" \
  private/var/root/Library/Preferences/com.apple.CoreBrightness.plist
sudo /usr/libexec/PlistBuddy -c "Set :${currentUserUID}:CBBlueReductionStatus:BlueReductionMode 1" \
  private/var/root/Library/Preferences/com.apple.CoreBrightness.plist

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true


# -----------------------------------------------------------------------------
# Trackpad, mouse, keyboard, touchbar, etc.
# -----------------------------------------------------------------------------

# Trackpad: Set tracking speed
defaults write -g com.apple.trackpad.scaling 0.875

# Make sure "natural" scrolling is enabled
defaults write -g com.apple.swipescrolldirection -bool true

# Enable Tab in modal dialogs
defaults write -g AppleKeyboardUIMode -int 2

# Enable press-and-hold for keys instead of key repeat
defaults write -g ApplePressAndHoldEnabled -bool true

# Set a decently fast keyboard repeat rate
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 25

# Adjust keyboard brightness in low light
sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Keyboard Enabled" -bool true
sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Keyboard Dim Time" -int 30

# Configure Control Strip (TouchBar)
defaults write com.apple.controlstrip MiniCustomized \
  '(com.apple.system.brightness, com.apple.system.volume, com.apple.system.mute, com.apple.system.media-play-pause)'
defaults write com.apple.controlstrip FullCustomized \
  '(com.apple.system.screencapture, NSTouchBarItemIdentifierFlexibleSpace, com.apple.system.group.brightness,
    com.apple.system.group.keyboard-brightness, com.apple.system.group.media, com.apple.system.group.volume,
    NSTouchBarItemIdentifierFlexibleSpace, com.apple.system.screen-lock)'

# Set language and text formats
defaults write -g AppleLanguages -array "en-US" "es-ES" "fr-CH"
defaults write -g AppleLocale -string "en_ES"
defaults write -g AppleMeasurementUnits -string "Centimeters"
defaults write -g AppleMetricUnits -bool true

# Configure spelling
defaults write -g NSPreferredSpellServers -array '(en, Apple)' '(es, Apple)' '(fr, Apple)'

# Disable auto-correct and the sort
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

# Stop/enable iTunes from responding to the keyboard media keys
# (It's the only way to stop it from opening when no other media app is running)
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null
# launchctl load -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

# Shortcuts: Move left a space with Cmd-Alt-[
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:79:enabled true" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:79:value:parameters:0 integer 91" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:79:value:parameters:1 integer 33" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:79:value:parameters:2 integer 1572864" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:80:enabled true" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:80:value:parameters:0 integer 91" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:80:value:parameters:1 integer 33" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:80:value:parameters:2 integer 1703936" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Shortcuts: Move right a space with Cmd-Alt-]
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:81:enabled true" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:81:value:parameters:0 integer 93" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:81:value:parameters:1 integer 30" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:81:value:parameters:2 integer 1572864" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:82:enabled true" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:82:value:parameters:0 integer 93" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:82:value:parameters:1 integer 30" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:82:value:parameters:2 integer 1703936" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Shortcuts: Move to main space with Cmd-Alt-\
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:118:enabled true" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:118:value:parameters:0 integer 92" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:118:value:parameters:1 integer 42" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:118:value:parameters:2 integer 1572864" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Disable annoying/dangerous/unnecessary global Shortcuts
# Shortcuts: Disable "Turn Dock Hiding On/Off"
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:52:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
# Shortcuts: Disable "Change the way Tab moves focus"
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:13:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
# Shortcuts: Disable "Show Mission Control"
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:32:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:34:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
# Shortcuts: Disable "Application windows"
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:33:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:35:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
# Shortcuts: Disable "Show Desktop"
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:36:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:37:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
# Shortcuts: Disable "Show Dashboard"
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:62:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:63:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
# Shortcuts: Disable accessibility shortcuts
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:59:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:162:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Configure custom keyboard layout
defaults write com.apple.HIToolbox AppleEnabledInputSources -array-add \
  '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>16383</integer><key>KeyboardLayout Name</key><string>US-ES International</string></dict>'
defaults write com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID -string \
  'org.sil.ukelele.keyboardlayout.custom-keyboard.us-esinternational'


# -----------------------------------------------------------------------------
# Dock, Dashboard, and spaces
# -----------------------------------------------------------------------------

# Set the icon size of Dock items to system defaults
defaults write com.apple.dock tilesize -int 64

# Enable Dock magnification
defaults write com.apple.dock magnification -int 1
defaults write com.apple.dock largesize -int 80

# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Enable App Exposé, show desktop and Mission Control gestures
defaults write com.apple.dock showAppExposeGestureEnabled -int 1
defaults write com.apple.dock showDesktopGestureEnabled -int 1
defaults write com.apple.dock showMissionControlGestureEnabled -int 1

# Disable the Launchpad gesture (pinch with thumb and three fingers)
defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

# Display Download as folder and view as a fan
# Other values for displays: 1 (Folder), 0 (Stack)
#                  showas: 1 (Fan), 2 (Grid),  3 (List), 0 (Automatic)
/usr/libexec/PlistBuddy -c "Set persistent-others:0:tile-data:displayas 1" ~/Library/Preferences/com.apple.dock.plist
/usr/libexec/PlistBuddy -c "Set persistent-others:0:tile-data:showas 1" ~/Library/Preferences/com.apple.dock.plist


# -----------------------------------------------------------------------------
# Finder
# -----------------------------------------------------------------------------

# Set home folder as the default location for new Finder windows
# For other paths, use e.g. `file://${HOME}/Desktop/` and `PfDe`
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Don't show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# Show all filename extensions
defaults write -g AppleShowAllExtensions -bool true

# Keep folders on top
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Keep view settings for icons as default on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:textSize 12" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:textSize 12" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:textSize 12" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Use column view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `Nlsv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Sort files by kind in column view
/usr/libexec/PlistBuddy -c "Set StandardViewOptions:ColumnViewOptions:ArrangeBy kipl" ~/Library/Preferences/com.apple.finder.plist

# Arrange by kind in Open/Save dialogs
defaults write com.apple.finder FK_ArrangeBy -string "Kind"

# Enable AirDrop over every interface, not only ethernet
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true

# Sidebar: Show computer, removables and ejectables only
/usr/libexec/PlistBuddy -c "Delete systemitems:VolumesList:0:Flags" ~/Library/Preferences/com.apple.sidebarlists.plist 2> /dev/null
defaults write com.apple.sidebarlists systemitems -dict-add ShowRemovable -bool true
defaults write com.apple.sidebarlists systemitems -dict-add ShowHardDisks -bool false
defaults write com.apple.sidebarlists systemitems -dict-add ShowEjectables -bool true

# Sidebar: Don't show tags
defaults write com.apple.finder ShowRecentTags -bool false

# Toolbar: Set a very minimal toolbar
/usr/libexec/PlistBuddy -c "Delete 'NSToolbar Configuration Browser':'TB Item Identifiers'" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers' array" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':0 string com.apple.finder.BACK" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':1 string NSToolbarFlexibleSpaceItem" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':2 string com.apple.finder.SWCH" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':3 string com.apple.finder.ARNG" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':4 string com.apple.finder.NFLD" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':5 string NSToolbarFlexibleSpaceItem" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':6 string com.apple.finder.SRCH" ~/Library/Preferences/com.apple.finder.plist


# -----------------------------------------------------------------------------
# TotalFinder
# -----------------------------------------------------------------------------

# Dock: Show progress bar in the Dock
defaults write com.binaryage.totalfinder TotalFinderShowDockProgressBar -bool true

# Menus: Hide icon in menu bar
defaults write com.binaryage.totalfinder TotalFinderShowStatusItem -bool false

# Menus: Allow path copying from context menus
defaults write com.binaryage.totalfinder TotalFinderCopyPathMenuEnabled -bool true

# Visor: Enable
defaults write com.binaryage.totalfinder TotalFinderVisorEnabled -bool true

# Visor: Disable hide on ESC
defaults write com.binaryage.totalfinder TotalFinderHideOnEscape -bool false

# Visor: Set slide up animation
defaults write com.binaryage.totalfinder TotalFinderUseFade -bool true
defaults write com.binaryage.totalfinder TotalFinderUseSlide -bool true
defaults write com.binaryage.totalfinder TotalFinderAnimationSpeed -float 0.3

# Visor: Show on screen with mouse cursor
defaults write com.binaryage.totalfinder TotalFinderScreen -int 0

# Visor: Show on all spaces
defaults write com.binaryage.totalfinder TotalFinderOnEverySpace -int 1

# Visor: Disable show on top of Dock
defaults write com.binaryage.totalfinder TotalFinderVisorOnDockLevel -bool false

# Visor: Disable free form window
defaults write com.binaryage.totalfinder TotalFinderVisorFreeForm -int 0

# Browser: Automatically adjust width in column view
defaults write com.binaryage.totalfinder TotalFinderColumnViewAutoWidthEnabled -bool false
defaults write com.binaryage.totalfinder TotalFinderColumnViewAutoWidthMaxColumnWidthEnabled -int 1
defaults write com.binaryage.totalfinder TotalFinderColumnViewAutoWidthMaxColumnWidth -int 250
defaults write com.binaryage.totalfinder TotalFinderColumnViewAutoWidthMinColumnWidthEnabled -int 1
defaults write com.binaryage.totalfinder TotalFinderColumnViewAutoWidthMinColumnWidth -int 200

# Tabs: Use narrow tabs bar
defaults write com.binaryage.totalfinder TotalFinderNarrowTabsBar -bool true

# Tabs: Open tabs with previous location
defaults write com.binaryage.totalfinder TotalFinderNewTabsWithCurrentTarget -bool true

# Shortcuts: Set favorites
/usr/libexec/PlistBuddy -c "Set TotalFinderShortcuts:ToggleVisor:Modifiers 524288" ~/Library/Preferences/com.binaryage.totalfinder.plist
/usr/libexec/PlistBuddy -c "Set TotalFinderShortcuts:ToggleVisor:KeyCode 48" ~/Library/Preferences/com.binaryage.totalfinder.plist
/usr/libexec/PlistBuddy -c "Set TotalFinderShortcuts:ShowSystemFiles:Modifiers 1179648" ~/Library/Preferences/com.binaryage.totalfinder.plist
/usr/libexec/PlistBuddy -c "Set TotalFinderShortcuts:ShowSystemFiles:KeyCode 47" ~/Library/Preferences/com.binaryage.totalfinder.plist
/usr/libexec/PlistBuddy -c "Set TotalFinderShortcuts:DualMode:Modifiers 1048576" ~/Library/Preferences/com.binaryage.totalfinder.plist
/usr/libexec/PlistBuddy -c "Set TotalFinderShortcuts:DualMode:KeyCode 32" ~/Library/Preferences/com.binaryage.totalfinder.plist

# Shortcuts: Disable unwanted
/usr/libexec/PlistBuddy -c "Set TotalFinderShortcuts:PinVisor:Modifiers 0" ~/Library/Preferences/com.binaryage.totalfinder.plist
/usr/libexec/PlistBuddy -c "Set TotalFinderShortcuts:PinVisor:KeyCode 0" ~/Library/Preferences/com.binaryage.totalfinder.plist
/usr/libexec/PlistBuddy -c "Set TotalFinderShortcuts:NarrowTabsBar:Modifiers 0" ~/Library/Preferences/com.binaryage.totalfinder.plist
/usr/libexec/PlistBuddy -c "Set TotalFinderShortcuts:NarrowTabsBar:KeyCode 0" ~/Library/Preferences/com.binaryage.totalfinder.plist


# -----------------------------------------------------------------------------
# Spotlight
# -----------------------------------------------------------------------------

# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

# Change indexing order and disable some search results
defaults write com.apple.spotlight orderedItems -array \
  '{"enabled" = 1; "name" = "APPLICATIONS";}' \
  '{"enabled" = 1; "name" = "SYSTEM_PREFS";}' \
  '{"enabled" = 1; "name" = "MENU_DEFINITION";}' \
  '{"enabled" = 1; "name" = "MENU_EXPRESSION";}' \
  '{"enabled" = 1; "name" = "MENU_CONVERSION";}' \
  '{"enabled" = 1; "name" = "CONTACT";}' \
  '{"enabled" = 1; "name" = "DIRECTORIES";}' \
  '{"enabled" = 1; "name" = "PDF";}' \
  '{"enabled" = 1; "name" = "DOCUMENTS";}' \
  '{"enabled" = 1; "name" = "IMAGES";}' \
  '{"enabled" = 1; "name" = "MENU_OTHER";}' \
  '{"enabled" = 1; "name" = "SOURCE";}' \
  '{"enabled" = 1; "name" = "FONTS";}' \
  '{"enabled" = 0; "name" = "MENU_SPOTLIGHT_SUGGESTIONS";}' \
  '{"enabled" = 0; "name" = "MENU_WEBSEARCH";}' \
  '{"enabled" = 0; "name" = "PRESENTATIONS";}' \
  '{"enabled" = 0; "name" = "SPREADSHEETS";}' \
  '{"enabled" = 0; "name" = "MUSIC";}' \
  '{"enabled" = 0; "name" = "MOVIES";}' \
  '{"enabled" = 0; "name" = "MESSAGES";}' \
  '{"enabled" = 0; "name" = "EVENT_TODO";}' \
  '{"enabled" = 0; "name" = "BOOKMARKS";}'

# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1

# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null

# Rebuild the index from scratch (Uncomment if needed)
# sudo mdutil -E / > /dev/null


# -----------------------------------------------------------------------------
# # Kill affected applications
# -----------------------------------------------------------------------------

for app in "Activity Monitor" "Calendar" "Contacts" "cfprefsd" \
  "Dock" "Finder" "SystemUIServer" "TotalFinder"; do
  killall "${app}" > /dev/null 2>&1
done

echo "Done. Note that some of these changes require a logout/restart to take effect."
