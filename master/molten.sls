{% from "master/map.jinja" import master with context %}
{% from "master/map.jinja" import master_ssl with context %}
{% from "master/map.jinja" import molten with context %}

install_nginx_on_master:
  pkg.installed:
    - name: nginx
  service.running:
    - name: nginx
    - enable: True

molten_nginx_config:
  file.managed:
    - name: {{ master.nginx_config_path }}/molten
    - source: salt://master/templates/molten_nginx.conf
    - template: jinja
    - context:
        cert_path: {{ master_ssl.cert_path }}
        key_path: {{ master_ssl.key_path }}
    - watch_in:
        - service: install_nginx_on_master
    - require:
        - pkg: install_nginx_on_master

molten-archive:
  archive.extracted:
    - name: {{ molten.install_dir}}
    - source: https://github.com/martinhoefling/molten/releases/download/v{{ molten.package.version }}/molten-{{ molten.package.version }}.tar.gz
    - source_hash: sha1={{ molten.package.sha1 }}
    - archive_format: tar
    - tar_options: v
    - if_missing: {{ molten.install_dir }}/{{ molten.package.version }}/

molten-symlink:
  file.symlink:
    - name: {{ molten.install_dir }}/molten
    - target: {{ molten.install_dir }}/molten-{{ molten.package.version }}
