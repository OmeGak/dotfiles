# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true

# pipenv config
export PIPENV_DEFAULT_PYTHON_VERSION=3.6
export PIPENV_VENV_IN_PROJECT=1
export WORKON_HOME=$HOME/.venvs

# virtualenv config
export PROJECT_HOME=$PROJECTS
export VIRTUALENVWRAPPER_HOOK_DIR=$DOT/python/venv-hooks
