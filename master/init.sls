{% from "master/map.jinja" import master with context %}
{% from "master/map.jinja" import master_ssl with context %}
{% set git_remotes = salt['pillar.get']('master:git_remotes', []) %}

install_master_package_dependencies:
  pkg.installed:
    - pkgs: {{ master.pkgs }}
    - refresh: True

install_master_python_dependencies:
  pip.installed:
    - names: {{ master.pip_deps }}

make_cloud_provider_dir:
  file.directory:
    - name: /etc/salt/cloud.providers.d
    - makedirs: True

make_cloud_profile_dir:
  file.directory:
    - name: /etc/salt/cloud.profiles.d
    - makedirs: True

configure_gitfs:
  file.managed:
    - name: /etc/salt/master.d/gitfs.conf
    - source: salt://master/templates/gitfs.conf
    - template: jinja
    - context:
        git_remotes: git_remotes

# Ensure salt services are enabled and running
salt_master_running:
  service.running:
    - name: salt-master
    - enable: True

salt_minion_running:
  service.running:
    - name: salt-minion
    - enable: True

# Either download and install TLS key and cert or generate a self-signed one
{% if master_ssl.cert_source %}
setup_master_ssl_cert:
  file.managed:
    - name: {{ master_ssl.cert_path }}
    - source: {{ master_ssl.cert_source }}

setup_master_ssl_key:
  file.managed:
    - name: {{ master_ssl.key_path }}
    - source: {{ master_ssl.key_path }}
{% else %}
setup_master_ssl_cert:
  module.run:
    - name: tls.create_self_signed_cert
    - tls_dir: ssl
    - bits: 2048
    - cacert_path: /etc
    {% for arg, val in salt['pillar.get']('master:ssl:cert_params', {}) %}
    - {{ arg }}: {{ val }}
    {% endfor %}
{% endif %}
