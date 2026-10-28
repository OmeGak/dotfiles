# Activate mise: the active tools' bin folders go on PATH, no shims
if (( $+commands[mise] )); then
  eval "$(mise activate zsh)"
  # Switch on cd only. The precmd hook runs mise at every prompt (about 25 ms
  # on an Intel Mac) to catch a config edited in place; `cd .` catches it too
  add-zsh-hook -d precmd _mise_hook_precmd
  # `mise shell` and `mise use` only change what the next hook reads, so
  # without the precmd one they refresh PATH here, and take effect at once
  functions[_mise_activate]=$functions[mise]
  mise() {
    local ret
    _mise_activate "$@"
    ret=$?
    case "${1:-}" in
      shell|sh|use|u) _mise_hook ;;
    esac
    return $ret
  }
fi
