
/home/ubuntu/.ssh/authorized_keys:
  file.managed:
    - source: salt://global/resources/authorized_keys
    - user: ubuntu
    - group: ubuntu
    - mode: 600
