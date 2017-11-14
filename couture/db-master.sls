
include:
  - .db

/etc/postgresql/9.6/main/postgresql.conf:
  file.managed:
    - source: salt://couture/resources/postgresql_master.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: postgresql-server-dev-9.6

sudo -u postgres psql -c "CREATE USER replicator REPLICATION LOGIN ENCRYPTED PASSWORD 'password';" || true:
  cmd.run
