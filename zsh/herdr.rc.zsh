# Terminal title for herdr tab names (see agents/herdr-plugins/tab-names).
# precmd: cwd; preexec: command name only (never arguments: they may hold secrets).
# Inside herdr, nudge a resync.

__herdr_title() {
  [[ -t 1 ]] || return
  local t=${1//[[:cntrl:]]/ }
  print -rn -- $'\e]2;'"$t"$'\a'
}

__herdr_nudge() {
  [[ $HERDR_ENV == 1 ]] || return
  ( command herdr plugin action invoke tab-names.sync >/dev/null 2>&1 </dev/null & ) 2>/dev/null
}

__herdr_precmd() {
  local d=${PWD/#$HOME/\~}
  [[ $d == "~" ]] || d=${d:t}
  __herdr_title "$d"
  __herdr_nudge
}

__herdr_preexec() {
  local words=(${(z)1})
  __herdr_title "${words[1]}"
  __herdr_nudge
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd __herdr_precmd
add-zsh-hook preexec __herdr_preexec
