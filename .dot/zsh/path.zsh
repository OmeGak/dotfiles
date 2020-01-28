buildpath() {
  local localpath="$HOME/.local/bin"
  local dotpath="$DOT/bin:$DOT/.dot/bin"
  local binpath="${dotpath}:${localpath}:$BREWDIR/bin:/usr/bin:/bin"
  local sbinpath="$BREWDIR/sbin:/usr/sbin:/sbin"
  echo "${binpath}:${sbinpath}"
}

buildmanpath() {
  [[ "$OS" == 'Darwin' ]] && echo "$BREWDIR/man" \
                          || echo "$BREWDIR/share/man"
}

# Explicitly run macOS path builder with clean paths, otherwise it scrambles it
if [ -x /usr/libexec/path_helper ]; then
  PATH="" MANPATH="" eval $(/usr/libexec/path_helper -s)
fi

# Export paths and prevent duplicates on `reload!`
export PATH="$(buildpath):$PATH"; typeset -U PATH
export MANPATH="$(buildmanpath):$MANPATH"; typeset -U MANPATH

# Export compiler paths
export PKG_CONFIG_PATH=""
export LD_LIBRARY_PATH=""
export LIBRARY_PATH=""
export CPATH=""

# Clean up
unset -f buildpath
unset -f buildmanpath
