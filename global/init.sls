/root/.vimrc:
  file.managed:
    - source: salt://global/resources/vimrc
    - user: root
    - group: root
    - mode: 644

{% if grains['os'] == 'Ubuntu' %}
include:
  - .ubuntu
{% endif %}
