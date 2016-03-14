{% from "master/map.jinja" import master with context %}
{% from "master/map.jinja" import master_ssl with context %}
{% from "master/map.jinja" import master_aws with context %}

install_master_package_dependencies:
  pkg.installed:
    - pkgs: {{ master.pkgs }}
    - refresh: True
    - reload_modules: True

install_master_python_dependencies:
  pip.installed:
    - names: {{ master.pip_deps }}
    - reload_modules: True

make_cloud_provider_dir:
  file.directory:
    - name: /etc/salt/cloud.providers.d
    - makedirs: True

make_cloud_profile_dir:
  file.directory:
    - name: /etc/salt/cloud.profiles.d
    - makedirs: True

make_master_config_directory:
  file.directory:
    - name: /etc/salt/master.d
    - makedirs: True

make_minion_config_directory:
  file.directory:
    - name: /etc/salt/minion.d
    - makedirs: True

{% for fname, settings in salt.pillar.get('salt_master:extra_configs', {}).items() %}
/etc/salt/master.d/{{fname}}.conf:
  file.managed:
    - source: salt://master/templates/conf-template.conf
    - template: jinja
    - context:
        config: {{ settings }}
    - watch_in:
        - service: salt_master_running
{% endfor %}

{% for fname, settings in salt.pillar.get('salt_master:minion_configs', {}).items() %}
/etc/salt/minion.d/{{fname}}.conf:
  file.managed:
    - source: salt://master/templates/conf-template.conf
    - template: jinja
    - context:
        config: {{ settings }}
    - watch_in:
        - service: salt_minion_running
{% endfor %}

# Ensure salt services are enabled and running
salt_master_running:
  service.running:
    - name: salt-master
    - enable: True

salt_minion_running:
  service.running:
    - name: salt-minion
    - enable: True

accept_minion_key:
  cmd.run:
    - name: salt-key -y -A
    - unless: "[[ `salt-key -l acc | wc -l` > 1 ]]"
