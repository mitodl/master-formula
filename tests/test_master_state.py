def test_package_dependencies_installed(Package):
    assert Package('salt-cloud').is_installed
    assert Package('salt-api').is_installed
    assert Package('salt-doc').is_installed
    assert Package('reclass').is_installed


def test_master_config_files(File):
    assert File('/etc/salt/master.d/gitfs.conf').exists
    assert File('/etc/salt/master.d/gitfs.conf').is_file


def test_cloud_config_directories(File):
    assert File('/etc/salt/cloud.providers.d').is_directory
    assert File('/etc/salt/cloud.profiles.d').is_directory
