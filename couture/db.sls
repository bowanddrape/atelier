
postgresql:
  pkg.installed

expect:
  pkg.installed

sudo -u postgres createdb couture || true:
  cmd.run

sudo -u postgres createuser -s -w root || true:
  cmd.run

bash /srv/couture/psql_setup.sh:
  cmd.run
