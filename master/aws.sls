{% from "master/map.jinja" import master with context %}
{% from "master/map.jinja" import master_aws with context %}

install_aws_python_dependencies:
  pip.installed:
    - names: {{ master_aws.pip_deps }}

create_aws_cloud_config:
  file.managed:
    - name: /etc/salt/cloud.providers.d/aws.conf
    - source: salt://master/templates/aws.conf
    - template: jinja
    - makedirs: True
    - context:
        aws_providers: {{ master_aws.providers }}

create_aws_ssh_key_directory:
  file.directory:
    - name: {{ master_aws.private_key_path }}
    - makedirs: True

create_aws_ssh_key:
  module.run:
    - name: boto_ec2.create_key
    - key_name: {{ master_aws.keyname }}
    - save_path: {{ master_aws.private_key_path }}/{{ master_aws.keyname }}
    - require:
        - file: create_aws_ssh_key_directory
    - unless: ls {{ master_aws_private_key_path }}/{{ master_aws.keyname }}
