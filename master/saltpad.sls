{% from "master/map.jinja" import master with context %}
{% from "master/map.jinja" import master_ssl with context %}

install_nginx_on_master:
  pkg.installed:
    - name: nginx

saltpad-archive:
  archive.extracted:
    - name: {{ master.saltpad.install_dir}}
    - source: https://github.com/Lothiraldan/saltpad/releases/download/{{ master.saltpad.version }}/dist.zip
    - source_hash: sha1=https://github.com/Lothiraldan/saltpad/releases/download/{{ master.saltpad.version }}/dist.zip.sha1
    - archive_format: zip
    - if_missing: {{ master.saltpad.install_dir }}/{{ master.saltpad.version }}/

set_saltpad_config:
  file.managed:
    - name: {{ master.saltpad.install_dir }}/settings.json
    - source: salt://master/templates/saltpad_config.json
    - replace: True
    - template: jinja
    - context:
        salt_domain: {{ master.domain }}

install_master_dhparam:
  file.managed:
    - name: /etc/salt/ssl/certs/dhparam.pem
    - source: {{ master_ssl.get('dhparam_source', 'salt://master/files/dhparam.pem') }}
    - mode: 644
    - makedirs: True

saltpad_nginx_config:
  file.managed:
    - name: {{ master.nginx_config_path }}/saltpad
    - source: salt://master/templates/saltpad_nginx.conf
    - template: jinja
    - context:
        cert_path: {{ master_ssl.cert_path }}
        key_path: {{ master_ssl.key_path }}
        root_path: {{ master.saltpad.install_dir }}
        server_name: {{ master.saltpad.server_name }}
    - require:
        - pkg: install_nginx_on_master
        - file: install_master_dhparam

remove_default_nginx_config:
  file.absent:
    - name: {{ master.nginx_config_path }}/default

saltpad_run_nginx:
  service.running:
    - name: nginx
    - enable: True
    - watch:
        - file: saltpad_nginx_config
