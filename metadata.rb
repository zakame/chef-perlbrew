name              'perlbrew'
license           'Apache-2.0'
maintainer        'Zak B. Elep'
maintainer_email  'zakame@cpan.org'
version           '0.5.1'
chef_version      '>= 14'

description       'Configures and Installs perlbrew'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url        'https://github.com/zakame/chef-perlbrew/issues'
source_url        'https://github.com/zakame/chef-perlbrew'

[ 'debian', 'ubuntu', 'centos', 'amazon' ].each do |os|
  supports os
end
