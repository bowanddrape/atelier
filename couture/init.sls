
include:
  - .db

copy couture source code to /srv/couture:
 file.recurse:
   - name: /srv/couture
   - source: salt://couture/src

setup nodejs_7.x:
 cmd.run:
   - name: "bash /srv/couture/nodejs_setup_7.x" 

#Install required packages
# package-name:
#   pkg.installed (pkg uses the native package manager)

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

libglu1-mesa:
  pkg.installed

xorg:
  pkg.installed

run npm install and ignore stderr:
  cmd.run:
    - name: "cd /srv/couture && npm install 2>/dev/null"

copy postgres slave config into targets:
  file.managed:
    - name: /etc/postgresql/9.5/main/postgresql.conf
    - source: salt://couture/resources/postgresql_slave.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: postgresql-server-dev-9.5

copy rc.local to /etc/:
  file.managed:
    - name: /etc/rc.local
    - source: salt://couture/resources/rc.local
    - user: root
    - group: root
    - mode: 744

{% if 'prod' in grains['roles'] %}
if target type is prod then copy .env:
  file.managed:
    - name: /srv/couture/.env
    - source: salt://couture/resources/.env
    - user: root
    - group: root
{% endif %}

{% if 'stag' in grains['roles'] %}
if target type is prod then copy .env:
  file.managed:
    - name: /srv/couture/.env
    - source: salt://couture/resources/.env_stag
    - user: root
    - group: root
{% endif %}

copy couture.service:
  file.managed:
    - name: /etc/systemd/system/couture.service
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
/etc/systemd/system/couture_shipment.service:
  file.managed:
    - source: salt://couture/resources/couture_shipment.service
    - user: root
    - group: root
    - mode: 644
/etc/systemd/system/couture_shipment.timer:
  file.managed:
    - source: salt://couture/resources/couture_shipment.timer
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
   - name: systemctl daemon-reload && systemctl enable couture_import_haute && systemctl enable couture_import_haute.timer && systemctl start couture_import_haute.timer && systemctl enable couture_shipment && systemctl enable couture_shipment.timer && systemctl start couture_shipment.timer && systemctl enable couture_emails && systemctl enable couture_emails.timer && systemctl start couture_emails.timer

set our dkim key:
  file.managed:
    - name: /etc/dkimkeys/default.private
    - source: salt://couture/resources/default.private
    - makedirs: True
    - user: root
    - group: root
    - mode: 600

opendkim:
  pkg.installed

sendmail:
  pkg.installed

configure opendkim:
  file.managed:
    - name: /etc/opendkim.conf
    - source: salt://couture/resources/opendkim.conf
    - user: root
    - group: root
    - mode: 644

configure sendmail:
  file.managed:
    - name: /etc/mail/sendmail.mc
    - source: salt://couture/resources/sendmail.mc
    - user: root
    - group: smmsp
    - mode: 644

regenerate sendmail conf:
  cmd.run:
    - name: m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf

restart opendkim:
  service.running:
    - name: opendkim
    - enable: True
    - reload: True

restart sendmail:
  service.running:
    - name: sendmail
    - enable: True
    - reload: True
{% endif %}
