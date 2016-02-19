{% from "master/map.jinja" import master with context %}

install_master_dependencies:
  pip.installed:
    - names: {{ master.pip-deps }}
  pkg.installed:
    - pkgs: {{ master.pkgs }}

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
    - source: salt://master/files/gitfs.conf
