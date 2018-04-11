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
