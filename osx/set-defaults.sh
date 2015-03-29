# Sets reasonable OS X defaults.
#
# Or, in other words, set shit how I like in OS X.
#
# The original idea (and a couple settings) were grabbed from:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.osx
#
# Run ./set-defaults.sh and you'll be good to go.

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# -----------------------------------------------------------------------------
# General & UI/UX
# -----------------------------------------------------------------------------

# Set computer name (as done via System Preferences → Sharing)
#sudo scutil --set ComputerName "oBook"
#sudo scutil --set HostName "oBook"
#sudo scutil --set LocalHostName "oBook"
#sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "oBook"

# Set sleep delay on charger (-c) and on battery (-b) in minutes
sudo pmset -c sleep 30
sudo pmset -b sleep 10

# Set display sleep delay in minutes
sudo pmset -c displaysleep 10
sudo pmset -b displaysleep 2

# Slightly dim the display when on battery
sudo pmset -b lessbright 1

# Disable/reset the sound effects on boot
# FIXME: couldn't make it work consistently :(
sudo nvram SystemAudioVolume=%00
# sudo nvram -d SystemAudioVolume

# Menu bar: hide unwanted icons
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
  defaults write "${domain}" dontAutoLoad -array \
    "/System/Library/CoreServices/Menu Extras/TextInput.menu" \
    "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
    "/System/Library/CoreServices/Menu Extras/Volume.menu" \
    "/System/Library/CoreServices/Menu Extras/User.menu"
done

# Menu bar: Alwasy show these icons
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

# Disable Resume for native apps
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable/enable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"
# defaults write com.apple.CrashReporter DialogType -string "crashreport"

# Disable smart quotes and dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable guest account
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

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

# # Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true


# -----------------------------------------------------------------------------
# Trackpad, mouse, keyboard, Bluetooth accessories, and input
# -----------------------------------------------------------------------------

# Trackpad: Set tracking speed
defaults write -g com.apple.trackpad.scaling 0.6875

# Make sure "natural" scrolling is enabled
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# Enable Tab in modal dialogs
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2

# Enable press-and-hold for keys instead of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool true

# Set a decently fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 25

# Adjust keyboard brightness in low light
sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Keyboard Enabled" -bool true
sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Keyboard Dim Time" -int 30

# Set language and text formats
defaults write NSGlobalDomain AppleLanguages -array "en" "es" "fr"
defaults write NSGlobalDomain AppleLocale -string "en_ES"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Stop/enable iTunes from responding to the keyboard media keys
# (It's the only way to stop it from opening when no other media app is running)
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null
# launchctl load -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

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
# Shortcuts: Disable "Mission Control controls"
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:79:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:80:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:81:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c "Set AppleSymbolicHotKeys:82:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist



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

# Set dock apps
defaults write com.apple.dock.plist persistent-apps '
    (
            {
            GUID = 812386433;
            "tile-data" =         {
                "bundle-identifier" = "com.apple.iChat";
                "dock-extra" = 1;
                "file-data" =             {
                    "_CFURLAliasData" = <00000000 00a60003 00010000 d1251ac4 0000482b 00000000 00000093 00032357 0000cbcd ed3f0000 00000920 fffe0000 00000000 0000ffff ffff0001 00040000 0093000e 001a000c 004d0065 00730073 00610067 00650073 002e0061 00700070 000f001a 000c004d 00610063 0069006e 0074006f 00730068 00200048 00440012 00194170 706c6963 6174696f 6e732f4d 65737361 6765732e 61707000 00130001 2f00ffff 0000>;
                    "_CFURLString" = "file:///Applications/Messages.app/";
                    "_CFURLStringType" = 15;
                };
                "file-label" = Messages;
                "file-mod-date" = 3419270463;
                "file-type" = 41;
                "parent-mod-date" = 3510249744;
            };
            "tile-type" = "file-tile";
        },
            {
            GUID = 2879970080;
            "tile-data" =         {
                "bundle-identifier" = "com.google.Chrome";
                "dock-extra" = 0;
                "file-data" =             {
                    "_CFURLAliasData" = <00000000 00e80003 00010000 d1251ac4 0000482b 00000000 0008f01b 0008f02e 0000d120 34160000 00000920 fffe0000 00000000 0000ffff ffff0001 00140008 f01b0008 f01a0008 e4b70008 e4b60008 e4b5000e 00240011 0047006f 006f0067 006c0065 00200043 00680072 006f006d 0065002e 00610070 0070000f 001a000c 004d0061 00630069 006e0074 006f0073 00680020 00480044 00120041 6f70742f 686f6d65 62726577 2d636173 6b2f4361 736b726f 6f6d2f67 6f6f676c 652d6368 726f6d65 2f6c6174 6573742f 476f6f67 6c652043 68726f6d 652e6170 70000013 00012f00 ffff0000>;
                    "_CFURLString" = "file:///opt/homebrew-cask/Caskroom/google-chrome/latest/Google%20Chrome.app/";
                    "_CFURLStringType" = 15;
                };
                "file-label" = "Google Chrome";
                "file-mod-date" = 3509731123;
                "file-type" = 41;
                "parent-mod-date" = 3509222444;
            };
            "tile-type" = "file-tile";
        },
            {
            GUID = 986363494;
            "tile-data" =         {
                "bundle-identifier" = "com.spotify.client";
                "dock-extra" = 0;
                "file-data" =             {
                    "_CFURLAliasData" = <00000000 00d00003 00010000 d1251ac4 0000482b 00000000 0008e59c 00139142 0000d137 889a0000 00000920 fffe0000 00000000 0000ffff ffff0001 00140008 e59c0008 e59b0008 e4b70008 e4b60008 e4b5000e 0018000b 00530070 006f0074 00690066 0079002e 00610070 0070000f 001a000c 004d0061 00630069 006e0074 006f0073 00680020 00480044 00120035 6f70742f 686f6d65 62726577 2d636173 6b2f4361 736b726f 6f6d2f73 706f7469 66792f6c 61746573 742f5370 6f746966 792e6170 70000013 00012f00 ffff0000>;
                    "_CFURLString" = "file:///opt/homebrew-cask/Caskroom/spotify/latest/Spotify.app/";
                    "_CFURLStringType" = 15;
                };
                "file-label" = Spotify;
                "file-mod-date" = 3510077594;
                "file-type" = 41;
                "parent-mod-date" = 3510079019;
            };
            "tile-type" = "file-tile";
        },
            {
            GUID = 2879970081;
            "tile-data" =         {
                "bundle-identifier" = "com.valvesoftware.steam";
                "dock-extra" = 0;
                "file-data" =             {
                    "_CFURLAliasData" = <00000000 00c80003 00010000 d1251ac4 0000482b 00000000 00093945 00093962 0000cf32 97070000 00000920 fffe0000 00000000 0000ffff ffff0001 00140009 39450009 39440008 e4b70008 e4b60008 e4b5000e 00140009 00530074 00650061 006d002e 00610070 0070000f 001a000c 004d0061 00630069 006e0074 006f0073 00680020 00480044 00120031 6f70742f 686f6d65 62726577 2d636173 6b2f4361 736b726f 6f6d2f73 7465616d 2f6c6174 6573742f 53746561 6d2e6170 70000013 00012f00 ffff0000>;
                    "_CFURLString" = "file:///opt/homebrew-cask/Caskroom/steam/latest/Steam.app/";
                    "_CFURLStringType" = 15;
                };
                "file-label" = Steam;
                "file-mod-date" = 3509057616;
                "file-type" = 41;
                "parent-mod-date" = 3509222444;
            };
            "tile-type" = "file-tile";
        },
            {
            GUID = 986363496;
            "tile-data" =         {
                "bundle-identifier" = "com.evernote.Evernote";
                "dock-extra" = 0;
                "file-data" =             {
                    "_CFURLAliasData" = <00000000 00d40003 00010000 d1251ac4 0000482b 00000000 00095c0f 0019bce6 0000d12d fa800000 00000920 fffe0000 00000000 0000ffff ffff0001 00140009 5c0f0009 5c0e0008 e4b70008 e4b60008 e4b5000e 001a000c 00450076 00650072 006e006f 00740065 002e0061 00700070 000f001a 000c004d 00610063 0069006e 0074006f 00730068 00200048 00440012 00376f70 742f686f 6d656272 65772d63 61736b2f 4361736b 726f6f6d 2f657665 726e6f74 652f6c61 74657374 2f457665 726e6f74 652e6170 70000013 00012f00 ffff0000>;
                    "_CFURLString" = "file:///opt/homebrew-cask/Caskroom/evernote/latest/Evernote.app/";
                    "_CFURLStringType" = 15;
                };
                "file-label" = Evernote;
                "file-mod-date" = 3509451392;
                "file-type" = 41;
                "parent-mod-date" = 3510251817;
            };
            "tile-type" = "file-tile";
        },
            {
            GUID = 2879970082;
            "tile-data" =         {
                "bundle-identifier" = "com.sublimetext.3";
                "dock-extra" = 0;
                "file-data" =             {
                    "_CFURLAliasData" = <00000000 00e80003 00010000 d1251ac4 0000482b 00000000 000ac2b1 00157758 0000d13a 18ad0000 00000920 fffe0000 00000000 0000ffff ffff0001 0014000a c2b1000a c2b00008 e4b70008 e4b60008 e4b5000e 00220010 00530075 0062006c 0069006d 00650020 00540065 00780074 002e0061 00700070 000f001a 000c004d 00610063 0069006e 0074006f 00730068 00200048 00440012 00446f70 742f686f 6d656272 65772d63 61736b2f 4361736b 726f6f6d 2f737562 6c696d65 2d746578 74332f42 75696c64 20333036 352f5375 626c696d 65205465 78742e61 70700013 00012f00 ffff0000>;
                    "_CFURLString" = "file:///opt/homebrew-cask/Caskroom/sublime-text3/Build%203065/Sublime%20Text.app/";
                    "_CFURLStringType" = 15;
                };
                "file-label" = "Sublime Text";
                "file-mod-date" = 3510245549;
                "file-type" = 41;
                "parent-mod-date" = 3510245553;
            };
            "tile-type" = "file-tile";
        },
            {
            GUID = 2926331018;
            "tile-data" =         {
                "bundle-identifier" = "com.googlecode.iterm2";
                "dock-extra" = 0;
                "file-data" =             {
                    "_CFURLAliasData" = <00000000 00c60003 00010000 d1251ac4 0000482b 00000000 0008f2fd 0014c625 0000d07d b7dc0000 00000920 fffe0000 00000000 0000ffff ffff0001 00140008 f2fd0008 f2fc0008 e4b70008 e4b60008 e4b5000e 00140009 00690054 00650072 006d002e 00610070 0070000f 001a000c 004d0061 00630069 006e0074 006f0073 00680020 00480044 0012002f 6f70742f 686f6d65 62726577 2d636173 6b2f4361 736b726f 6f6d2f69 7465726d 322f322e 302f6954 65726d2e 61707000 00130001 2f00ffff 0000>;
                    "_CFURLString" = "file:///opt/homebrew-cask/Caskroom/iterm2/2.0/iTerm.app/";
                    "_CFURLStringType" = 15;
                };
                "file-label" = iTerm;
                "file-mod-date" = 3497899996;
                "file-type" = 41;
                "parent-mod-date" = 3510173630;
            };
            "tile-type" = "file-tile";
        }
    )
'


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

# Don't show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool false

# Allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Keep view settings for icons as default on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:textSize 12" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:textSize 12" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:textSize 12" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Use column view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `Nlsv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Enable AirDrop over every interface, not only ethernet
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Enable the MacBook Air SuperDrive on any Mac
sudo nvram boot-args="mbasd=1"

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

# Sidebar: Don't show shared elements
/usr/libexec/PlistBuddy -c "Set networkbrowser:CustomListProperties:com.apple.NetworkBrowser.backToMyMacEnabled false" ~/Library/Preferences/com.apple.sidebarlists.plist
/usr/libexec/PlistBuddy -c "Set networkbrowser:CustomListProperties:com.apple.NetworkBrowser.bonjourEnabled false" ~/Library/Preferences/com.apple.sidebarlists.plist
/usr/libexec/PlistBuddy -c "Set networkbrowser:CustomListProperties:com.apple.NetworkBrowser.connectedEnabled false" ~/Library/Preferences/com.apple.sidebarlists.plist

# Sidebar: Don't show tags
defaults write com.apple.finder ShowRecentTags -bool false

# Sidebar: Favorites
defaults write com.apple.sidebarlists favoriteitems '
    {
        Controller = CustomListItems;
        CustomListItems =     (
                    {
                Alias = <00000000 00920003 00010000 d1251ac4 0000482b 00000000 000293ef 000621e0 0000d125 23fb0000 00000920 fffe0000 00000000 0000ffff ffff0001 00040002 93ef000e 000e0006 006f006d 00650067 0061006b 000f001a 000c004d 00610063 0069006e 0074006f 00730068 00200048 00440012 000c5573 6572732f 6f6d6567 616b0013 00012f00 00150002 000dffff 0000>;
                CustomItemProperties =             {
                    "com.apple.LSSharedFileList.Binding" = <646e6962 00000000 01000000 00000000 00000000 00000000 00000000 00000000 00000000 646c6675 02000000 00000000>;
                    "com.apple.LSSharedFileList.TemplateSystemSelector" = 1935820909;
                };
                Name = Home;
            },
                    {
                Alias = <00000000 00a00003 00010000 d1251ac4 0000482b 00000000 000621e0 000ad731 0000d127 f7bd0000 00000920 fffe0000 00000000 0000ffff ffff0001 00080006 21e00002 93ef000e 00100007 00440072 006f0070 0062006f 0078000f 001a000c 004d0061 00630069 006e0074 006f0073 00680020 00480044 00120014 55736572 732f6f6d 6567616b 2f44726f 70626f78 00130001 2f000015 0002000d ffff0000>;
                CustomItemProperties =             {
                    "com.apple.LSSharedFileList.Binding" = <646e6962 00000000 01000000 00000000 00000000 00000000 00000000 00000000 00000000 72646c66 02000000 00000000>;
                    "com.apple.LSSharedFileList.TemplateSystemSelector" = 1935820388;
                };
                Name = Dropbox;
            },
                    {
                Alias = <00000000 00b00003 00010000 d1251ac4 0000482b 00000000 000621e0 000b3a39 0000d127 fa020000 00000920 fffe0000 00000000 0000ffff ffff0001 00080006 21e00002 93ef000e 001a000c 0047006f 006f0067 006c0065 00200044 00720069 00760065 000f001a 000c004d 00610063 0069006e 0074006f 00730068 00200048 00440012 00195573 6572732f 6f6d6567 616b2f47 6f6f676c 65204472 69766500 00130001 2f000015 0002000d ffff0000>;
                CustomItemProperties =             {
                    "com.apple.LSSharedFileList.Binding" = <646e6962 00000000 04000000 00000000 00000000 00000000 00000000 1d000000 00000000 2d000000 00000000 66696c65 3a2f2f6c 6f63616c 686f7374 2f557365 72732f6f 6d656761 6b2f476f 6f676c65 25323044 72697665 2f000000 0281b2ba 41300000 00000000 00646e69 62000000 00010000 00000000 00000000 00000000 00000000 00000000 00000000 0072646c 66120000 00000000 00>;
                    "com.apple.LSSharedFileList.TemplateSystemSelector" = 1061109567;
                };
                Name = "Google Drive";
            },
                    {
                Alias = <00000000 00940003 00010000 d1251ac4 0000482b 00000000 00000002 00000093 0000d021 2e3b0000 00000920 fffe0000 00000000 0000ffff ffff0001 0000000e 001a000c 00410070 0070006c 00690063 00610074 0069006f 006e0073 000f001a 000c004d 00610063 0069006e 0074006f 00730068 00200048 00440012 000c4170 706c6963 6174696f 6e730013 00012f00 ffff0000>;
                CustomItemProperties =             {
                    "com.apple.LSSharedFileList.Binding" = <646e6962 00000000 01000000 00000000 00000000 00000000 00000000 00000000 00000000 73707061 02000000 00000000>;
                    "com.apple.LSSharedFileList.TemplateSystemSelector" = 1935819120;
                };
                Name = Applications;
            },
                    {
                Alias = <00000000 009e0003 00010000 d1251ac4 0000482b 00000000 000621e0 000621e3 0000d125 20140000 00000920 fffe0000 00000000 0000ffff ffff0001 00080006 21e00002 93ef000e 00140009 0044006f 0077006e 006c006f 00610064 0073000f 00120008 0055006e 00740069 0074006c 00650064 00120016 55736572 732f6f6d 6567616b 2f446f77 6e6c6f61 64730013 00012f00 00150002 000dffff 0000>;
                CustomItemProperties =             {
                    "com.apple.LSSharedFileList.Binding" = <646e6962 00000000 01000000 00000000 00000000 00000000 00000000 00000000 00000000 666e7764 02000000 00000000>;
                    "com.apple.LSSharedFileList.TemplateSystemSelector" = 1935819884;
                };
                Name = Downloads;
            },
                    {
                Alias = <00000000 009e0003 00010000 d1251ac4 0000482b 00000000 000621e0 00062219 0000d125 20140000 00000920 fffe0000 00000000 0000ffff ffff0001 00080006 21e00002 93ef000e 000e0006 004d006f 00760069 00650073 000f001a 000c004d 00610063 0069006e 0074006f 00730068 00200048 00440012 00135573 6572732f 6f6d6567 616b2f4d 6f766965 73000013 00012f00 00150002 000dffff 0000>;
                CustomItemProperties =             {
                    "com.apple.LSSharedFileList.Binding" = <646e6962 00000000 01000000 00000000 00000000 00000000 00000000 00000000 00000000 636f7666 02000000 00000000>;
                    "com.apple.LSSharedFileList.TemplateSystemSelector" = 1935822198;
                };
                Name = Movies;
            },
                    {
                Alias = <00000000 009a0003 00010000 d1251ac4 0000482b 00000000 000621e0 0006221b 0000d125 20140000 00000920 fffe0000 00000000 0000ffff ffff0001 00080006 21e00002 93ef000e 000c0005 004d0075 00730069 0063000f 001a000c 004d0061 00630069 006e0074 006f0073 00680020 00480044 00120012 55736572 732f6f6d 6567616b 2f4d7573 69630013 00012f00 00150002 000dffff 0000>;
                CustomItemProperties =             {
                    "com.apple.LSSharedFileList.Binding" = <646e6962 00000000 01000000 00000000 00000000 00000000 00000000 00000000 00000000 696b7073 02000000 00000000>;
                    "com.apple.LSSharedFileList.TemplateSystemSelector" = 1935822195;
                };
                Name = Music;
            },
                    {
                Alias = <00000000 00a40003 00010000 d1251ac4 0000482b 00000000 000621e0 0006221d 0000d125 20140000 00000920 fffe0000 00000000 0000ffff ffff0001 00080006 21e00002 93ef000e 00120008 00500069 00630074 00750072 00650073 000f001a 000c004d 00610063 0069006e 0074006f 00730068 00200048 00440012 00155573 6572732f 6f6d6567 616b2f50 69637475 72657300 00130001 2f000015 0002000d ffff0000>;
                CustomItemProperties =             {
                    "com.apple.LSSharedFileList.Binding" = <646e6962 00000000 01000000 00000000 00000000 00000000 00000000 00000000 00000000 c4726f6d 02000000 00000000>;
                    "com.apple.LSSharedFileList.TemplateSystemSelector" = 1935822947;
                };
                Name = Pictures;
            },
                    {
                CustomItemProperties =             {
                    "com.apple.LSSharedFileList.SpecialItemIdentifier" = "com.apple.LSSharedFileList.IsMeetingRoom";
                };
                Name = "domain-AirDrop";
                URL = "nwnode://domain-AirDrop";
            }
        );
        CustomListProperties =     {
            "com.apple.LSSharedFileList.Restricted.upgraded" = 9027;
        };
    }
'

# Toolbar: Set a very minimal toolbar
/usr/libexec/PlistBuddy -c "Delete 'NSToolbar Configuration Browser':'TB Item Identifiers'" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers' array" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':0 string com.apple.finder.BACK" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':1 string NSToolbarSpaceItem" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':2 string NSToolbarSpaceItem" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':3 string com.apple.finder.SWCH" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':4 string com.apple.finder.ARNG" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':5 string com.apple.finder.NFLD" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':6 string NSToolbarFlexibleSpaceItem" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Add 'NSToolbar Configuration Browser':'TB Item Identifiers':7 string com.apple.finder.SRCH" ~/Library/Preferences/com.apple.finder.plist


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

# Browser: Folders on top
defaults write com.binaryage.totalfinder TotalFinderFoldersOnTop -bool true

# Browser: Automatically adjust width in column view
defaults write com.binaryage.totalfinder TotalFinderColumnViewAutoWidthEnabled -bool true
defaults write com.binaryage.totalfinder TotalFinderColumnViewAutoWidthMaxColumnWidth -int 250
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
/usr/libexec/PlistBuddy -c "Set TotalFinderShortcuts:FoldersOnTop:Modifiers 0" ~/Library/Preferences/com.binaryage.totalfinder.plist
/usr/libexec/PlistBuddy -c "Set TotalFinderShortcuts:FoldersOnTop:KeyCode 0" ~/Library/Preferences/com.binaryage.totalfinder.plist


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

# Re-launch TotalFinder
open /Applications/TotalFinder.app

echo "Done. Note that some of these changes require a logout/restart to take effect."
