{% from "master/map.jinja" import master, master_config with context %}

include:
  - master

master-config:
  file.managed:
    - name: {{ master.conf_file }}
    - source: salt://master/templates/conf.jinja
    - template: jinja
    - context:
      config: {{ master_config }}
    - watch_in:
      - service: master
    - require:
      - pkg: master
