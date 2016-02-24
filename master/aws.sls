{% from "master/map.jinja" import master with context %}
{% from "master/map.jinja" import master_aws with context %}
include:
  - master

install_aws_python_dependencies:
  pip.installed:
    - names: {{ master_aws.pip_deps }}
    - reload_modules: True

create_aws_cloud_config:
  file.managed:
    - name: /etc/salt/cloud.providers.d/aws.conf
    - source: salt://master/templates/aws.conf
    - template: jinja
    - makedirs: True
    - context:
        aws_providers: {{ master_aws.providers }}
    - watch_in:
        - service: salt_master_running

{% for provider in master_aws.providers %}
create_aws_ssh_key_directory:
  file.directory:
    - name: {{ provider.private_key_path }}
    - makedirs: True

create_aws_ssh_key:
  module.run:
    - name: boto_ec2.create_key
    - key_name: {{ provider.keyname }}
    - save_path: {{ provider.private_key_path }}/{{ provider.keyname }}
    - require:
        - file: create_aws_ssh_key_directory
    - unless: ls {{ provider.private_key_path }}/{{ provider.keyname }}
{% endfor %}
