alias sublpath="$SHELL -l -c 'echo $PATH | tr : \"\n\"'"

sublwhich() {
  $SHELL -l -c "/usr/bin/which $1"
}
