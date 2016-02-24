def test_package_dependencies_installed(Package):
    assert Package('salt-cloud').is_installed
    assert Package('salt-api').is_installed
    assert Package('salt-doc').is_installed
    assert Package('reclass').is_installed


def test_cloud_config_directories(File):
    assert File('/etc/salt/cloud.providers.d').is_directory
    assert File('/etc/salt/cloud.profiles.d').is_directory


def test_gitfs_config(File):
    gitfs_config = File('/etc/salt/master.d/gitfs.conf')
    assert gitfs_config.exists
    assert gitfs_config.contains('github.com/blarghmatey')


def test_extra_configs(File):
    ext_pillar = File('/etc/salt/master.d/ext_pillar.conf')
    assert ext_pillar.exists
    assert ext_pillar.contains('reclass')


def test_extra_minion_configs(File):
    minion_settings = File('/etc/salt/minion.d/extra_settings.conf')
    assert minion_settings.exists
    assert minion_settings.contains('id: secretary')
