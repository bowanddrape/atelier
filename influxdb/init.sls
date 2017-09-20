
get influx packages:
 cmd.run:
   - name: "curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add - && echo \"deb https://repos.influxdata.com/ubuntu/ xenial stable\" | sudo tee /etc/apt/sources.list.d/influxdb.list"

install packages:
  pkg.installed:
    - pkgs:
      - influxdb
    - refresh: True

