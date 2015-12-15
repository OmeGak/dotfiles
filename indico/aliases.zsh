# Run indico with SSL (asumes ssl cert present in home folder)
alias ndc="WERKZEUG_DEBUG_PIN=off indico runserver --quiet --keep-base-url --host 127.0.0.1 --port 8443 --with-ssl --ssl-key ~/ansible.key --ssl-cert ~/ansible.crt --enable-evalex --evalex-from `myip`"

# Initializes required services
alias ndc-init="pg_ctl start; zdaemon -C "$ZODB_CONF" start; sudo =nginx -c "$NGINX_CONF"; redis-server&; maildump_ctl start"

# Launch dblog
ndc-dblog() {
  local args="-i indico/web/assets/blueprint.py -i indico/web/flask/session.py:62 -i 5:indico_ravem/plugin.py -i 5:indico_ravem/util.py -i 4:indico/modules/users/models/settings.py:100 -I /assets/js-vars/user.js"
  echo -e "\033]0;INDICO DB LOG\007\c" && python $PROJECTS/indico/bin/utils/db_log.py -t 5 $=args $*
}
