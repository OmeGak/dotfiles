function indico_dbdiff() {
    createdb indico_dbdiff && \
        psql indico_dbdiff -c 'CREATE EXTENSION unaccent; CREATE EXTENSION pg_trgm;' >/dev/null && \
        INDICO_CONF_OVERRIDE='{"SQLAlchemyDatabaseURI": "postgresql:///indico_dbdiff"}' indico db prepare 2>/dev/null >/dev/null && \
        for suffix ('' _dbdiff); do pg_dump -s -f /tmp/indico_dbdiff${suffix}.sql indico${suffix}; done && \
        dropdb indico_dbdiff && \
        apgdiff /tmp/indico_dbdiff.sql /tmp/indico_dbdiff_dbdiff.sql | pyg sql && \
        rm /tmp/indico_dbdiff.sql /tmp/indico_dbdiff_dbdiff.sql
}

function indico_dbdiff_2() {
    createdb indico_dbdiff && \
        psql indico_dbdiff -c 'CREATE EXTENSION unaccent; CREATE EXTENSION pg_trgm;' >/dev/null && \
        INDICO_CONF_OVERRIDE='{"SQLAlchemyDatabaseURI": "postgresql:///indico_dbdiff"}' indico db prepare 2>/dev/null >/dev/null && \
        echo YES | INDICO_CONF_OVERRIDE='{"SQLAlchemyDatabaseURI": "postgresql:///indico_dbdiff"}' indico db downgrade 2>/dev/null >/dev/null && \
        INDICO_CONF_OVERRIDE='{"SQLAlchemyDatabaseURI": "postgresql:///indico_dbdiff"}' indico db upgrade 2>/dev/null >/dev/null && \
        for suffix ('' _dbdiff); do pg_dump -s -f /tmp/indico_dbdiff${suffix}.sql indico${suffix}; done && \
        dropdb indico_dbdiff && \
        apgdiff /tmp/indico_dbdiff.sql /tmp/indico_dbdiff_dbdiff.sql | pyg sql && \
        rm /tmp/indico_dbdiff.sql /tmp/indico_dbdiff_dbdiff.sql
}

function pyg() {
    pygmentize -l $1 -f terminal256 -O style=native,bg=dark
}
