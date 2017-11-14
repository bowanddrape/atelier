service postgresql stop:
  cmd.run

# Cleaning up old cluster directory
sudo -u postgres rm -rf /var/lib/postgresql/9.6/main:
  cmd.run

# Starting base backup as replicator
# FIXME this doesn't work as it asks for a password
# FIXME for staging, the backup url is 10.0.0.220!
sudo -u postgres pg_basebackup -X stream -h 10.0.0.63 -D /var/lib/postgresql/9.6/main -U replicator -v -P:
  cmd.run

# Writing recovery.conf file
/var/lib/postgresql/9.6/main/recovery.conf:
  file.managed:
    - source: salt://couture/resources/recovery.conf
    - user: root
    - group: root
    - mode: 644

service postgresql start:
  cmd.run
