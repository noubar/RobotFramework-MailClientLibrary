
from os.path import abspath, dirname, join
from setuptools import setup, find_packages
from src.MailClientLibrary.version import VERSION

CURDIR = dirname(abspath(__file__))

CLASSIFIERS = '''
Development Status :: 5 - Production/Stable
Operating System :: OS Independent
Programming Language :: Python
Programming Language :: Python :: 3
Programming Language :: Python :: 3.7
Programming Language :: Python :: 3.8
Programming Language :: Python :: 3.9
Programming Language :: Python :: 3.10
License :: OSI Approved :: MIT License
Topic :: Software Development :: Testing
Topic :: Communications :: Email :: Email Clients (MUA)
Topic :: Communications :: Email :: Post-Office :: IMAP
Topic :: Communications :: Email :: Post-Office :: POP3
Framework :: Robot Framework
Framework :: Robot Framework :: Library
'''.strip().splitlines()
with open(join(CURDIR, 'README.md')) as f:
    DESCRIPTION = f.read()
with open(join(CURDIR, 'requirements.txt')) as f:
    REQUIREMENTS = f.read().splitlines()

setup(
    name             = 'robotframework-mailclient',
    version          = VERSION,
    description      = 'Mail Client library for Robot Framework',
    long_description = DESCRIPTION,
    long_description_content_type="text/markdown",
    author           = 'noubar',
    url              = 'https://github.com/noubar/MailClientLibrary',
    license          = 'Apache License 2.0',
    keywords         = 'robotframework testing testautomation mailtesting mailclient mail imap smtp pop3',
    platforms        = 'any',
    classifiers      = CLASSIFIERS,
    python_requires  = '>=3.7, <4',
    install_requires = REQUIREMENTS,
    package_dir      = {'MailClientLibrary': 'src/MailClientLibrary'},
    packages         = find_packages('src'),
    package_data     ={'MailClientLibrary': ['*.pyi']}
)
