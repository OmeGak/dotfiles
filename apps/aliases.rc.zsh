if [[ $(which xkcdpass) ]]; then
  alias xkcdpass="xkcdpass --interactive --numwords=4 --valid-chars='[a-z]' --max=8 --delimiter='-'"
fi
