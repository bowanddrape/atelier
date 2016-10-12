base:
  pkgrepo.managed:
    - humanname: New Relic
    - name: deb http://apt.newrelic.com/debian/ newrelic non-free
    - file: /etc/apt/sources.list.d/newrelic.list
    - require_in:
      - pkg: newrelic-sysmond
    - gpgcheck: 1
    - key_url: https://download.newrelic.com/548C16BF.gpg

newrelic-sysmond:
  pkg.installed

newrelic-php5:
  pkg.installed

newrelic_setup:
  cmd.run:
    - name: "nrsysmond-config --set license_key=670a033a6d22e99764e57682292d135815ca12fb"

/etc/php/7.0/fpm/conf.d/newrelic.ini:
  file.managed:
    - source: salt://haute/resources/newrelic.ini
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php-fpm

newrelic_service:
  service.running:
    - name: newrelic-sysmond
