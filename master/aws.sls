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
create_aws_ssh_key_directory_for_{{ provider.name }}:
  file.directory:
    - name: /etc/salt/keys/aws/
    - makedirs: True

{% if provider.get('key_pair') %}
place_private_key_for_{{ provider.name }}_on_master:
  file.managed:
    - name: /etc/salt/keys/aws/{{ provider.keyname }}.pem
    - mode: '0400'
    - contents: |
        {{ provider.key_pair.private|indent(8) }}
    - require_in:
        - boto_ec2: create_aws_ssh_key_for_{{ provider.name }}
{% else %}
generate_keypair_for_{{ provider.name }}_on_master:
  cmd.run:
    - name: ssh-keygen -b 4096 -C '{{ provider.keyname }}@AWS_EC2' -f /etc/salt/keys/aws/{{ provider.keyname }}.pem -m PEM -t rsa -q -P ''
    - creates: /etc/salt/keys/aws/{{ provider.keyname }}.pem
    - require_in:
        - boto_ec2: create_aws_ssh_key_for_{{ provider.name }}
{% endif %}

create_aws_ssh_key_for_{{ provider.name }}:
  boto_ec2.key_present:
    - name: {{ provider.keyname }}
    - upload_public: __slot__:salt:cmd.run(cmd='ssh-keygen -f /etc/salt/keys/aws/{{ provider.keyname }}.pem -e')
    - region: {{ provider.get('region', 'us-east-1') }}
    - require:
        - file: create_aws_ssh_key_directory_for_{{ provider.name }}
  file.managed:
    - name: /etc/salt/keys/aws/{{ provider.keyname }}.pem
    - mode: '0400'
{% endfor %}
