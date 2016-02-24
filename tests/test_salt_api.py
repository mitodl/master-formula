def test_salt_api_installed(Package):
    assert Package('salt-api').is_installed


def test_salt_running(Service):
    assert Service('salt-api').is_running
    assert Service('salt-api').is_enabled


def test_salt_api_config(File):
    assert File("/etc/salt/master.d/netapi.conf").exists


def test_api_user_created(User):
    assert User('apiadmin').exists
    assert User('apiadmin').shell == '/bin/false'


def test_api_listening(Socket):
    assert Socket('tcp://0.0.0.0:8080').is_listening


def test_tls_cert_created(File):
    assert File('/etc/salt/ssl/certs/salt.yourdomain.com.crt').exists
    assert File('/etc/salt/ssl/certs/salt.yourdomain.com.key').exists


def test_dhparam_created(File):
    assert File('/etc/salt/ssl/certs/dhparam.pem').exists
