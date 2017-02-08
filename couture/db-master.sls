
include:
  - .db

sudo -u postgres psql -c "CREATE USER replicator REPLICATION LOGIN ENCRYPTED PASSWORD 'password';" || true:
  cmd.run
