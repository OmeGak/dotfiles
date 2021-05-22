# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true

# pipenv config
export PIPENV_DEFAULT_PYTHON_VERSION=3.9
export PIPENV_VENV_IN_PROJECT=1
export WORKON_HOME=$HOME/.venvs
