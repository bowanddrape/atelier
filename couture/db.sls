
add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main":
  cmd.run 
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -:
  cmd.run
apt-get update:
  cmd.run

postgresql-9.6:
  pkg.installed

postgresql-server-dev-9.6:
  pkg.installed

postgresql-9.6-plv8:
  pkg.installed

sudo -u postgres createdb couture || true:
  cmd.run

sudo -u postgres createuser -s -w root || true:
  cmd.run

sudo -u postgres psql -c "ALTER ROLE root WITH PASSWORD 'password';" || true:
  cmd.run

/etc/postgresql/9.6/main/pg_hba.conf:
  file.managed:
    - source: salt://couture/resources/pg_hba.conf
    - user: root
    - group: root
    - mode: 644
