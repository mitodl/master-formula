{% from "master/map.jinja" import master with context %}
{% from "master/map.jinja" import master_ssl with context %}

install_salt_api:
  pkg.installed:
    - name: salt-api

{% for user in master.api_users %}
{% set user_pass = salt.shadow.gen_password(user.password) %}
create_api_user_{{ user.name }}:
  user.present:
    - name: {{ user.name }}
    - password: {{ user_pass }}
    - createhome: False
    - shell: /bin/false
{% endfor %}


# Either download and install TLS key and cert or generate a self-signed one
{% if master_ssl.cert_source %}
setup_master_ssl_cert:
  file.managed:
    - name: /etc/salt/ssl/certs/{{ master_ssl.cert_path }}
    - source: {{ master_ssl.cert_source }}
    - makedirs: True

setup_master_ssl_key:
  file.managed:
    - name: {{ master_ssl.key_path }}
    - source: {{ master_ssl.key_source }}
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

salt_api_running:
  service.running:
    - name: salt-api
    - enable: True
