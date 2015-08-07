name              "perlbrew"
license           "Apache 2.0"
maintainer        "J.R. Mash"
maintainer_email  "jrmash@cpan.org"
version          "0.2.0"

description       "Configures and Installs perlbrew"
issues_url        "https://github.com/jrmash/perlbrew/issues"
source_url        "https://github.com/jrmash/perlbrew"

depends "build-essential"

[ 'debian', 'ubuntu', 'centos', 'amazon' ].each do |os|
  supports os
end
