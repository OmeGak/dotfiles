# Run indico with SSL (asumes ssl cert present in home folder)
alias ndc="indico runserver --quiet --with-ssl --ssl-key ~/host.key --ssl-cert ~/host.cert --enable-evalex --evalex-from `myip`"
