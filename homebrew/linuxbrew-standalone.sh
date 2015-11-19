#!/usr/bin/env bash
# Adapted standalone installation script
# Original: https://github.com/Homebrew/linuxbrew/wiki/Standalone-Installation

set -e
BREWDIR="$(brew --prefix)"
LIB64DIR="/usr/lib/x86_64-linux-gnu"

# Check for gcc
if [[ -z "$(brew ls --versions gcc 2> /dev/null || true)" ]]; then
  pprint info-warn "Brewing gcc. This will take about 2h. Ready to go? [Y/n]"

  case $(readone) in
    y|Y)
      sudoplz
      pprint newline
      pprint newline;;
    *)
      exit 1;;
  esac

  # Link libraries
  mkdir -p $BREWDIR/lib
  yes no | ln -is $BREWDIR/lib $BREWDIR/lib64 > /dev/null 2>&1
  yes no | ln -is $LIB64DIR/libstdc++.so.6 $BREWDIR/lib/ > /dev/null 2>&1
  yes no | ln -is $LIB64DIR/libgcc_s.so.1 $BREWDIR/lib/ > /dev/null 2>&1
  yes no | sudo ln -is /usr/lib/x86_64-linux-gnu /usr/lib64 > /dev/null 2>&1

  # Prepare environment
  unset HOMEBREW_CC

  # Install compiler tool chain
  brew tap homebrew/dupes
  brew install glibc
  brew unlink glibc
  brew install zlib
  brew link glibc
  brew install patchelf
  brew install gcc --with-glibc --only-dependencies
  brew install gcc --with-glibc || true

  # Cleanup
  rm -f $BREWDIR/lib/{libstdc++.so.6, libgcc_s.so.1}
  rm -f $HOME/.linuxbrew/lib/{libstdc++.so.6,libgcc_s.so.1}
  brew unlink gcc && brew link gcc
fi

export HOMEBREW_CC=gcc
pinstall brew bzip2
pinstall brew curl
pinstall brew expat
pinstall brew coreutils
pinstall brew findutils
pinstall brew gawk
pinstall brew gnu-sed
pinstall brew gnu-which
pinstall brew grep
# pinstall brew libpng
pinstall brew libxml2
pinstall brew libxslt
pinstall brew make
pinstall brew ncurses
pinstall brew readline
pinstall brew ruby

pprint info-ok "Homebrew is standalone"
exit 0
