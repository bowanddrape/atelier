
include:
  - .db

/srv/couture:
  file.recurse:
    - source: salt://couture/src

bash /srv/couture/nodejs_setup_7.x:
  cmd.run

build-essential:
  pkg.installed

libpq-dev:
  pkg.installed

nodejs:
  pkg.installed

npm:
  pkg.installed

node-less:
  pkg.installed

sendmail:
  pkg.installed

libglu1-mesa:
  pkg.installed

xorg:
  pkg.installed

cd /srv/couture && npm install 2>/dev/null:
  cmd.run


/etc/postgresql/9.5/main/postgresql.conf:
  file.managed:
    - source: salt://couture/resources/postgresql_slave.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: postgresql-server-dev-9.5

/etc/rc.local:
  file.managed:
    - source: salt://couture/resources/rc.local
    - user: root
    - group: root
    - mode: 744

{% if 'prod' in grains['roles'] %}
/srv/couture/.env:
  file.managed:
    - source: salt://couture/resources/.env
    - user: root
    - group: root
{% endif %}

/etc/systemd/system/couture.service:
  file.managed:
    - source: salt://couture/resources/couture.service
    - user: root
    - group: root
    - mode: 644

systemctl daemon-reload:
  cmd.run
systemctl enable couture.service:
  cmd.run
systemctl stop couture.service:
  cmd.run
systemctl start couture.service:
  cmd.run

{% if 'couture-cron' in grains['roles'] %}
/etc/systemd/system/couture_import_haute.service:
  file.managed:
    - source: salt://couture/resources/couture_import_haute.service
    - user: root
    - group: root
    - mode: 644
/etc/systemd/system/couture_import_haute.timer:
  file.managed:
    - source: salt://couture/resources/couture_import_haute.timer
    - user: root
    - group: root
    - mode: 644
/etc/systemd/system/couture_emails.service:
  file.managed:
    - source: salt://couture/resources/couture_emails.service
    - user: root
    - group: root
    - mode: 644
/etc/systemd/system/couture_emails.timer:
  file.managed:
    - source: salt://couture/resources/couture_emails.timer
    - user: root
    - group: root
    - mode: 644
enable couture_hourly timer:
  cmd.run:
   - name: systemctl daemon-reload && systemctl enable couture_import_haute && systemctl enable couture_import_haute.timer && systemctl start couture_import_haute.timer && systemctl enable couture_emails && systemctl enable couture_emails.timer && systemctl start couture_emails.timer
{% endif %}
