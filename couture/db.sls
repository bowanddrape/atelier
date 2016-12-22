
postgresql:
  pkg.installed

postgresql-server-dev-9.5:
  pkg.installed

postgresql-9.5-plv8:
  pkg.installed

#pgxnclient:
#  pkg.installed

# git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /home/ubuntu/depot_tools:
# cd /home/ubuntu && /home/ubuntu/depot_tools/fetch v8:
# PATH=/home/ubuntu/depot_tools:"$PATH" ./depot_tools/gclient sync:
# cd /home/ubuntu/v8 && make GYPFLAGS="-Dcomponent=shared_library" x64.release:
# ln -sf /home/ubuntu/v8/out/x64.release/lib.target/* /usr/lib/:
# ln -sf /home/ubuntu/v8/include/*.h /usr/include/:


expect:
  pkg.installed

sudo -u postgres createdb couture || true:
  cmd.run

sudo -u postgres createuser -s -w root || true:
  cmd.run

bash /srv/couture/psql_setup.sh:
  cmd.run
