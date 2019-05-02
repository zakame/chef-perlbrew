name              'perlbrew'
license           'Apache-2.0'
maintainer        'Zak B. Elep'
maintainer_email  'zakame@cpan.org'
version           '0.4.0'
chef_version      '>= 12.5'

description       'Configures and Installs perlbrew'
issues_url        'https://github.com/zakame/chef-perlbrew/issues'
source_url        'https://github.com/zakame/chef-perlbrew'

depends 'build-essential'

[ 'debian', 'ubuntu', 'centos', 'amazon' ].each do |os|
  supports os
end
