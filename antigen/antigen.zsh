# Load antigen framework
source "$ZSH/.antigen/antigen.zsh"

# Load antigen modules
antigen bundles <<EOBUNDLES
  brew-cask
  pip
  zsh-users/zsh-completions src
  zsh-users/zsh-syntax-highlighting
EOBUNDLES

# Apply modules
antigen apply
