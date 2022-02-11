# path
alias path='echo $PATH | tr : "\n"'

# fattest directories
alias fatd="gdu -sh *(/D) | gsort -rh | head -10"
alias fatdr="gdu -Sh | gsort -rh | head -10"

# -- Replacements --------------------------------------------------------------

# date
(( $+commands[gdate] )) && DATE="gdate" || DATE="date"
alias now="$DATE --rfc-3339=seconds"
unset DATE

# top
if (( $+commands[glances] )); then
  alias top="glances -2"
fi

# -- Snippets ------------------------------------------------------------------

# Download website for full offline navigation
# Source: http://www.kossboss.com/linux---wget-full-website
if (( $+commands[wget] )); then
  alias wget-full="wget --recursive --no-parent --page-requisites --adjust-extension --convert-links --timestamping \
                        --user-agent=mozilla --limit-rate=200k --random-wait --execute robots=off"
fi

if (( $+commands[lsof] )); then
  alias listening="sudo lsof -iTCP -sTCP:LISTEN -n -P"
fi


# -- Compatibility -------------------------------------------------------------

if [[ "$OS" == "Linux" ]]; then
  alias pbcopy="xclip -selection clipboard"
  alias pbpaste="xclip -selection clipboard -o"
fi

if [[ "$OS" == "Darwin" ]]; then
  alias tac='tail -r'
fi
