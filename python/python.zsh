# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true

# cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

# Install global packages
syspip() {
  if [[ "$(uname -s)" == "Linux" ]]; then
    sudo="sudo"
  else
    sudo=""
  fi
  PIP_REQUIRE_VIRTUALENV="" $sudo pip "$@"
}
