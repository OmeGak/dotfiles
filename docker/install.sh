#!/usr/bin/env bash
# shellcheck source=../.dot/functions/try
source $DOT/.dot/functions/try

if [[ $OS == 'Linux' ]]; then
  pprint info-warn "Step skipped: Better not install in Linux"
  exit 0
fi

# XXX: Workaround until the completion files are correctly named upstream
# https://github.com/docker/for-mac/issues/1948
completions_dir="/Applications/Docker.app/Contents/Resources/etc"
completions=("docker" "docker-compose" "docker-machine")
for completion in ${completions[*]}; do
  completion_bundled="${completions_dir}/${completion}.zsh-completion"
  completion_fixed="${completions_dir}/_${completion}"
  if [[ ! $(checklink "${completion_bundled}" "${completion_fixed}") ]]; then
    pprint info-go "Installing completions for ${completion}"
    # XXX: zsh seems not to load completion files if they are symlinks here
    mv "${completion_bundled}" "${completion_fixed}"
    mksymlink "${completion_fixed}" "${completion_bundled}"
  fi
done

exit $TRY_CODE
