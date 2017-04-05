if [[ $(which keybase) ]]; then
  alias pgp-clip="keybase pgp export | pbcopy | echo 'PGP public key copied to clipboard'"
fi
