def test_aws_config_installed(File):
    aws_provider = File('/etc/salt/cloud.providers.d/aws.conf')
    assert aws_provider.exists
    assert aws_provider.contains('driver: ec2')


def test_boto_installed(PythonPackage):
    assert PythonPackage('boto').is_installed


def test_ssh_key_created(File):
    assert File('/etc/salt/keys/aws/salt-master').exists
