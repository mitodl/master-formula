import pytest


@pytest.fixture()
def PythonPackage(Command):
    class PipClass():
        def __init__(self, pkg_name, pip_bin=None):
            self.pip_dict = {}
            self.pkg_name = pkg_name
            if pip_bin:
                args = ['%s freeze', pip_bin]
            else:
                args = ['pip freeze']
            for pkg in Command.check_output(*args).split('\n'):
                name, version = pkg.strip().split('==')
                self.pip_dict[name] = version

        @property
        def is_installed(self):
            return bool(self.pip_dict.get(self.pkg_name))

        @property
        def version(self, pkg_name):
            return self.pip_dict.get(self.pkg_name)
    return PipClass
