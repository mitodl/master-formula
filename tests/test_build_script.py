def test_salt_installed(Package):
    assert Package('salt-minion').is_installed
    assert Package('salt-master').is_installed


def test_libcloud_installed(PythonPackage):
    assert PythonPackage('apache-libcloud').is_installed


def test_salt_running(Service):
    assert Service('salt-minion').is_running
    assert Service('salt-minion').is_enabled
    assert Service('salt-master').is_running
    assert Service('salt-master').is_enabled


def test_salt_directories_present(File):
    assert File("/srv/salt").is_directory
    assert File("/srv/pillar").is_directory
    assert File("/srv/formulas").is_directory
