{% from "master/map.jinja" import master with context %}

include:
  - .services

{% for fname, settings in salt.pillar.get('salt_master:extra_configs', {}).items() %}
/etc/salt/master.d/{{fname}}.conf:
  file.managed:
    - contents: |
        {{ settings | yaml(False) | indent(8) }}
    - watch_in:
        - service: salt_master_running
    - makedirs: True
{% endfor %}

{% for fname, settings in salt.pillar.get('salt_master:minion_configs', {}).items() %}
/etc/salt/minion.d/{{fname}}.conf:
  file.managed:
    - contents: |
        {{ settings | yaml(False) | indent(8) }}
    - watch_in:
        - service: salt_minion_running
    - makedirs: True
{% endfor %}

{% for fname, settings in salt.pillar.get('salt_master:cloud_configs', {}).items() %}
/etc/salt/cloud.d/{{fname}}.conf:
  file.managed:
    - contents: |
        {{ settings | yaml(False) | indent(8) }}
    - watch_in:
        - service: salt_master_running
    - makedirs: True
{% endfor %}

/etc/systemd/system/salt-proxy.service:
  file.managed:
    - name: /etc/systemd/system/salt-proxy@.service
    - source: salt://master/templates/salt_proxy.service
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
        - file: /etc/systemd/system/salt-proxy@.service

{% for proxyid in salt.pillar.get('salt_master:proxy_configs:apps') %}
enable_salt_proxy_{{proxyid}}:
  service.running:
    - name: salt-proxy@{{ proxyid }}.service
    - enable: True
{% endfor %}
