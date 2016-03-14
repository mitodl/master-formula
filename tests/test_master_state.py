def test_package_dependencies_installed(Package):
    assert Package('salt-cloud').is_installed
    assert Package('salt-api').is_installed


def test_cloud_config_directories(File):
    assert File('/etc/salt/cloud.providers.d').is_directory
    assert File('/etc/salt/cloud.profiles.d').is_directory


def test_extra_configs(File):
    ext_pillar = File('/etc/salt/master.d/ext_pillar.conf')
    extfs = File('/etc/salt/master.d/extfs.conf')
    assert ext_pillar.exists
    assert ext_pillar.contains('reclass')
    assert extfs.exists
    assert extfs.contains('git_remotes')


def test_extra_minion_configs(File):
    minion_settings = File('/etc/salt/minion.d/extra_settings.conf')
    assert minion_settings.exists
    assert minion_settings.contains('id: secretary')
