import pytest


@pytest.mark.saltpad
def test_nginx_installed(Service, Package):
    assert Package('nginx').is_installed
    assert Service('nginx').is_running
    assert Service('nginx').is_enabled


@pytest.mark.saltpad
def test_saltpad_files_present(File):
    assert File('/var/www/saltpad').is_directory
    assert File('/var/www/saltpad/settings.json').exists


@pytest.mark.saltpad
def test_saltpad_nginx_config_present(File):
    assert File('/etc/nginx/sites-enabled/saltpad').exists


@pytest.mark.saltpad
def test_nginx_listening(Socket):
    assert Socket('tcp://0.0.0.0:80').is_listening
    assert Socket('tcp://:::80').is_listening
    assert Socket('tcp://0.0.0.0:443').is_listening
    assert Socket('tcp://:::443').is_listening
