{% from "master/map.jinja" import master with context %}
{% from "master/map.jinja" import master_ssl with context %}
{% from "master/map.jinja" import master_aws with context %}

include:
  - .config
  - .services

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

accept_minion_key:
  cmd.run:
    - name: salt-key -y -A
    - unless: "[[ `salt-key -l acc | wc -l` > 1 ]]"
