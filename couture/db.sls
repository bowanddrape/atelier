
postgresql:
  pkg.installed

postgresql-server-dev-9.5:
  pkg.installed

postgresql-9.5-plv8:
  pkg.installed

sudo -u postgres createdb couture || true:
  cmd.run

sudo -u postgres createuser -s -w root || true:
  cmd.run

sudo -u postgres psql -c "ALTER ROLE root WITH PASSWORD 'password';" || true:
  cmd.run

/etc/postgresql/9.5/main/postgresql.conf:
  file.managed:
    - source: salt://couture/resources/postgresql.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: postgresql-server-dev-9.5

/etc/postgresql/9.5/main/pg_hba.conf:
  file.managed:
    - source: salt://couture/resources/pg_hba.conf
    - user: root
    - group: root
    - mode: 644
