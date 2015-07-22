name             'net-radio-archive'
maintainer       'motchang'
maintainer_email 'motchang@gmail.com'
license          'All rights reserved'
description      'Installs/Configures net-radio-archive'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'rbenv', '~> 1.7.1'
depends 'selinux', '~> 0.5.0'
depends 'yum-repoforge'
depends 'yum-epel'
depends 'yum-remi'
depends 'git'
