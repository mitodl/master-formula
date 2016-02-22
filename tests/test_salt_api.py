def test_salt_api_installed(Package):
    assert Package('salt-api').is_installed


def test_salt_running(Service):
    assert Service('salt-api').is_running
    assert Service('salt-api').is_enabled


def test_salt_api_config(File):
    assert File("/etc/salt/master.d/netapi.conf").exists
