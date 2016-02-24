{% from "master/map.jinja" import master with context %}
{% from "master/map.jinja" import master_ssl with context %}

{% for user in master.api_users %}
{% set user_pass = salt.shadow.gen_password(user.password) %}
create_api_user_{{ user.name }}:
  user.present:
    - name: {{ user.name }}
    - password: {{ user_pass }}
    - createhome: False
    - shell: /bin/false
    - watch_in:
        file: create_salt_api_config
{% endfor %}


# Either download and install TLS key and cert or generate a self-signed one
{% if master_ssl.cert_source %}
setup_master_ssl_cert:
  file.managed:
    - name: /etc/salt/ssl/certs/{{ master_ssl.cert_path }}
    - source: /etc/salt/ssl/certs/{{ master_ssl.cert_source }}
    - makedirs: True

setup_master_ssl_key:
  file.managed:
    - name: {{ master_ssl.key_path }}
    - source: {{ master_ssl.key_path }}
    - makedirs: True
{% else %}
setup_master_ssl_cert:
  module.run:
    - name: tls.create_self_signed_cert
    - tls_dir: ssl
    - cacert_path: /etc/salt/
    {% for arg, val in salt.pillar.get('salt_master:ssl:cert_params', {}).items() -%}
    - {{ arg }}: {{ val }}
    {% endfor -%}
{% endif %}

create_salt_api_config:
  file.managed:
    - name: /etc/salt/master.d/netapi.conf
    - source: salt://master/templates/netapi.conf
    - makedirs: True
    - template: jinja
    - context:
        api_users: {{ master.api_users }}
        cert_path: {{ master_ssl.cert_path }}
        key_path: {{ master_ssl.key_path }}
        salt_domain: {{ master.domain }}

salt_api_running:
  service.running:
    - name: salt-api
    - enable: True
    - watch:
        - file: create_salt_api_config
