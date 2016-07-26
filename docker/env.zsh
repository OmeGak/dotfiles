# Configure Docker client
if exists docker-machine; then
  eval $(docker-machine env 2> /dev/null)
fi
