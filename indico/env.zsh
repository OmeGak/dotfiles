export INDICO_DBDIR=/usr/local/var/postgres
export ZODB_CONF=$PROJECTS/indico/etc/zdctl.conf
export NGINX_CONF=$DOT/indico/nginx.conf

# Default pg_ctl data dir
export PGDATA=$INDICO_DBDIR
