#!/usr/bin/env bash
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
  completion_source="${completions_dir}/${completion}.zsh-completion"
  completion_target="${completions_dir}/_${completion}"
  if [[ ! $(checklink "${completion_source}" "${completion_target}") ]]; then
    pprint info-go "Installing completions for ${completion}"
    # XXX: zsh seems not to load completion files if they are symlinks here
    mv "${completion_source}" "${completion_target}"
    mksymlink "${completion_target}" "${completion_source}"
  fi
done

exit $TRY_CODE
