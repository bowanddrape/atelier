include:
   - .newrelic

nginx:
  pkg.installed

memcached:
  pkg.installed

php-mysql:
  pkg.installed

php-memcached:
  pkg.installed

php-redis:
  pkg.installed

php-mcrypt:
  pkg.installed

php-fpm:
  pkg.installed

php-gd:
  pkg.installed

php7.0-soap:
  pkg.installed

php7.0-mbstring:
  pkg.installed

php7.0-curl:
  pkg.installed

php7.0-xml:
  pkg.installed

memcached_service:
  service.running:
    - name: memcached

/etc/nginx/sites-available/default:
  file.managed:
    - source: salt://haute/src/nginx/haute
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: nginx

nginx_restart:
  service.running:
    - name: nginx
    - watch:
      - file: /etc/nginx/sites-available/default

/etc/php/7.0/fpm/php.ini:
  file.managed:
    - source: salt://haute/resources/php.ini
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php-fpm

php_restart:
  service.running:
    - name: php7.0-fpm
    - watch:
      - file: /etc/php/7.0/fpm/php.ini

/src/haute:
  file.recurse:
    - source: salt://haute/src
    - keep_symlinks: true
    - clean: true

add_write_access_to_fs_cache:
  cmd.run:
    - name: "chown -R www-data:www-data /src/haute/cache && chown www-data:www-data /src/haute/log"

add_write_access_to_upload_dir:
  cmd.run:
    - name: "chown -R www-data:www-data /src/haute/web/uploads"

add_more_write_access_to_random_files:
  cmd.run:
    - name: "touch /src/haute/web_admin/orders.xml && chown www-data:www-data /src/haute/web_admin/orders.xml"

ln_zoora_dirs:
  cmd.run:
    - name: "ln -sf /src/haute /opt/zoora && ln -sf /src/haute /opt/haute"

nfs-kernel-server:
  pkg.installed

make_efs_mountpoint:
  cmd.run:
    - name: "mkdir -p /efs"

setup_fstab:
  file.managed:
    - name: /etc/fstab
    - source: salt://haute/resources/fstab

ln_efs_originals:
  cmd.run:
    - name: "ln -s /efs/originals /src/haute/web/originals"

ln_efs_renders:
  cmd.run:
    - name: "ln -s /efs/renders /src/haute/web/renders"

ln_sf:
  cmd.run:
    - name: "ln -s /src/haute/lib/symfony-1.4.20/data/web/sf /src/haute/web/sf"
