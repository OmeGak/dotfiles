# Fixes the "gyp: No Xcode or CLT version detected!" errors on `npm install` after macOS updates
# Source: https://stackoverflow.com/a/60982835/1901977
alias npm-fix-gyp='sudo echo "$(xcode-select --print-path)"; xcode-select --install'
