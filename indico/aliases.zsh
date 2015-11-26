# Run indico with SSL (asumes ssl cert present in home folder)
alias ndc="WERKZEUG_DEBUG_PIN=off indico runserver --quiet --keep-base-url --host 127.0.0.1 --port 8443 --with-ssl --ssl-key ~/ansible.key --ssl-cert ~/ansible.crt --enable-evalex --evalex-from `myip`"

# Initializes required services
alias ndc-init="pg_ctl start; zdaemon -C "$ZODB_CONFIG" start; sudo =nginx -c "$NGINX_CONF"; redis-server&; maildump_ctl start"
