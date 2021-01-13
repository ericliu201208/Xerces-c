import re, os
from conans import ConanFile, tools

def get_version(path_to_cmake_file):
    try:
        content = tools.load(path_to_cmake_file)
        version = re.search(r'project\([\s\S]*VERSION\s+([0-9][0-9\.]*)[\s)]{1}',
                            content, re.MULTILINE).group(1)
        return version.strip()
    except Exception:
        raise IOError(f'Cannot retrieve VERSION from {path_to_cmake_file}')


class Package(ConanFile):
    name = "XercesC"
    version = "3.2.3+v1.0.0"
    license = "Apache Software License 2.0"
    description = "a validating XML parser written in a portable subset of C++."
    url = 'https://github.com/hexagon-geo-surv/xerces-c'
    build_policy = "never"

    settings = "os", "arch", "compiler", "build_type"
    options = {'runtime_shared': [True, False]}
    default_options = {'runtime_shared': True}

    def build_requirements(self):
        if (self.settings.arch == "armv7"):
            self.build_requires('wcelibcex/1.0.0-v1.0.1@leica/stable')

    def imports(self):
        self.copy('*')

    def package(self):
        self.copy('*', src=self.source_folder)
