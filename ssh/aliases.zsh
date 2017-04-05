# Pipe ssh public key to clipboard
ssh-clip() {
  SSH_KEY=~/.ssh/id_rsa.pub
  if [[ -e $SSH_KEY ]]; then
    more $SSH_KEY | pbcopy | echo 'SSH public key copied to clipboard'
  else
    echo 'No SSH key found'
  fi
}
