PATH="${BREWDIR}/opt/postgresql@14/bin:${PATH}"
# Adds libpq5.6, required by psycopg2 Python package
LD_LIBRARY_PATH="$BREWDIR/opt/postgresql@14/lib/postgresql@14:${LD_LIBRARY_PATH}"
