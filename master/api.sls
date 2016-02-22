{% from "master/map.jinja" import master with context %}
{% from "master/map.jinja" import master_ssl with context %}

{% for user in master.api_users %}
create_api_user_{{ user.name }}:
  user.present:
    - name: {{ user.name }}
    - password: {{ user.password }}
    - createhome: False
    - shell: /bin/false
    - watch_in:
        file: create_salt_api_config
{% endfor %}

create_salt_api_config:
  file.managed:
    - name: /etc/salt/master.d/netapi.conf
    - source: salt://master/templates/netapi.conf
    - template: jinja
    - context:
        api_users: {{ master.api_users }}
        cert_path: {{ master_ssl.cert_path }}
        key_path: {{ master_ssl.key_path }}

salt_api_running:
  service.running:
    - name: salt-api
    - enable: True
    - watch:
        - file: create_salt_api_config
