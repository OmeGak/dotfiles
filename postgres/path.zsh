PATH="${BREWDIR}/opt/postgresql@9.6/bin:${PATH}"
# Adds libpq5.6, required by psycopg2 Python package
LD_LIBRARY_PATH="$BREWDIR/opt/postgresql@9.6/lib:${LD_LIBRARY_PATH}"
