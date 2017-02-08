
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

cd /srv/couture && npm install 2>/dev/null:
  cmd.run


{% if 'couture-db' in grains['roles'] %}
include:
  - .db
{% endif %}

