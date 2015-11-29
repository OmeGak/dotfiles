alias ktinit="kinit -kt $HOME/.keytab"
alias ktstart="k5start -f $HOME/.keytab -U -b -K 10"

if [[ $(uname -s) == 'Darwin' ]]; then
  alias ktutil="ktutil -k $HOME/.keytab"

  # Add a keytab for a principal
  ktadd() {
    local principal
    echo -n "Principal: "
    read principal
    echo -n "Password: "
    read -s password
    ktutil add -p ${principal} --password=${password} -e aes256-cts-hmac-sha1-96 -V 1
    ktutil add -p ${principal} --password=${password} -e arcfour-hmac-md5 -V 1
  }
fi
