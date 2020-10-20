[![Cookbook Version](https://img.shields.io/cookbook/v/perlbrew.svg)](https://supermarket.chef.io/cookbooks/perlbrew)
[![Build Status](https://travis-ci.org/zakame/chef-perlbrew.svg)](https://travis-ci.org/zakame/chef-perlbrew)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)

# SYNOPSIS

    # Method 1 - Include this cookbook's recipes in your cookbook/recipe:
    include_recipe 'perlbrew'
    include_recipe 'perlbrew::profile'

    # Method 2 - Use this cookbook's resources in your cookbook/recipe:
    perlbrew '/opt/perlbrew' do
      perls         ['perl-5.30.2', 'perl-5.14.4']
    end
    perlbrew_profile ''/etc/profile.d/perlbrew.sh'

# DESCRIPTION

This cookbook provides resources and recipes that can be used to
configure, install, and manage the [Perlbrew](https://perlbrew.pl)
environment.

This cookbook is tested on the following platforms:

* Amazon Linux 2
* CentOS/RHEL 7.x
* Debian 10.x
* Ubuntu 20.04 LTS

Unlisted platforms in the same family, of similar or equivalent versions
may work with or without modification to this cookbook.  Pull requests
to add support for other platforms are welcome.

Perlbrew requires a system perl and the following programs to be
available during the installation process:

* curl
* patch

Perlbrew compiles perl from source and requires a standard compiler
toolchain to be available; this cookbook will install this toolchain
automatically, if they are missing.

# ATTRIBUTES

### perlbrew_root

    node['perlbrew']['perlbrew_root'] = '/opt/perlbrew'

Sets the `PERLBREW_ROOT` environment variable.

### perls

    node['perlbrew']['perls'] = ["perl-5.14.2", "perl-5.12.3"]

Set an array of perls to install upon running the `perlbrew` recipe.

### install_options

    node['perlbrew']['install_options'] = '--noman --notest'

Set a string of command line options for `perlbrew install`, such as
`-Dusethreads`.

### cpanm_options

    node['perlbrew']['cpanm_options'] = '--notest'

Set a string of command line options for `cpanm`.

### self_upgrade

    node['perlbrew']['self_upgrade'] = true

Automatically install the latest perlbrew version, `true` by default.

# RECIPES

### perlbrew

Installs/updates perlbrew along with
[patchperl](https://metacpan.org/pod/Devel::PatchPerl) and
[cpanm](https://metacpan.org/pod/App::cpanminus).  This is required for
use of the `perlbrew_*` resources.  Optionally installs perls specified
in the `node['perlbrew']['perls']` attribute list.

### perlbrew::profile

This recipe installs a file in `/etc/profile.d` that enables perlbrew
for all users, though the standard caveats mentioned in the perlbrew
documentation do apply.

# RESOURCES

### perlbrew

    # install perlbrew then perl-5.30.2
    perlbrew '/opt/perlbrew' do
      perls ['perl-5.30.2']
      action :install
    end

    # remove perlbrew
    perlbrew '/opt/perlbrew' do
      action :remove
    end

This resource provides actions to install / remove perlbrew using the directory
specified in the `node['perlbrew']['perlbrew_root']` attribute.

* Attributes
  * :perls - An array of strings representing perls to brew / install.
  * :upgrade - A boolean flag to disable/enable the automatic upgrading of perlbrew. 

### perlbrew_profile

    # set a perlbrew profile for all users, controlled by root
    perlbrew_profile '/etc/profile.d/perlbrew.sh' do
      mode     0644
      owner    'root'
      group    'root'
      template 'perlbrew.sh.erb'
      action   :install
    end

    # remove a perlbrew profile
    perlbrew_profile '/etc/profile.d/perlbrew.sh' do
      action :remove
    end

This resource provides actions to install / remove the shell script that enables
perlbrew for all users.

* Attributes
  * :mode - The file's default permissions.
  * :group - The file's group association.
  * :owner - The file's owner.
  * :template - The template used to create the file.

### perlbrew_perl

    # perlbrew install perl-5.14.2 --noman --notest
    perlbrew_perl 'perl-5.14.2' do
      install_options '--noman --notest'
      action          :install
    end

    # perlbrew install perl-5.14.2 --as 5.14
    perlbrew_perl '5.14' do
      version 'perl-5.14.2'
    end

    # perlbrew uninstall perl-5.14.2
    perlbrew_perl 'perl-5.14.2' do
      action :remove
    end

This resource provides actions to brew and install perls into `node['perlbrew']['perlbrew_root']`.

* Attributes
  * :install_options - The options to be provided during brewing / installation.
  * :version - The version of perl to install, in the `perl-X.Y.Z` format that perlbrew expects.

### perlbrew_switch

    # turn off active perlbrews and switch to system perl
    perlbrew_switch 'off'

    # switch to perl-5.14.2
    perlbrew_switch 'perl-5.14.2'

This resource provides an action to switch between brewed perl installations / system perl.

### perlbrew_lib

    # create a 'mylib' local::lib for perl-5.14.2
    perlbrew_lib 'mylib' do
      perlbrew 'perl-5.14.2'
      action   :create
    end

    # ditto
    perlbrew_lib 'perl-5.14.2@mylib'

    # remove 'perl-5.14.2@mylib'
    perlbrew_lib 'perl-5.14.2@mylib' do
      action :delete
    end

This resource creates or removes a perlbrew-based local::lib library for a particular perl.

* Attributes
  * :perlbrew - The brewed perl to attach the library to (e.g. perl-5.14.2), and it is not
     installed, the `perlbrew_perl` resource will be used to brew and install it.  If this 
     attribute is not specified, it will be derived from the `perlbrew_lib` name.

### perlbrew_cpanm

    # install some modules into perl-5.14.2@mylib
    perlbrew_cpanm 'Modern Perl modules' do
      modules  ['Modern::Perl', 'Task::Kensho']
      perlbrew 'perl-5.14.2@mylib'
      action   :install
    end

This resource installs CPAN modules to a given perlbrew perl or local::lib using
cpanm (App::cpanminus).

* Attributes
  * :modules - The list of module names to pass to `cpanm`.
  * :perlbrew - The brewed perl (and optional library) to use for installing modules.

### perlbrew_run

    # execute a script under perl-5.14.2@mylib
    perlbrew_run 'hello.pl' do
      perlbrew 'perl-5.14.2@mylib'
      action   :run
    end

    # execute a perl script string
    perlbrew_run 'hello world' do
      perlbrew 'perl-5.14.2@mylib'
      command 'perl -wE "say q{Hello World}"'
    end

This resource runs a bash command in the context of a given perlbrew perl or local::lib.

* Attributes
  * :command - The bash command to run, defaulting to the resource name
    if not specified.
  * :cwd - The directory to change into prior to running the command.
  * :environment - The hash of environment variables to set prior to
    running the command
  * :perlbrew - The brewed perl (and optional library) to use for
    running the command.

# AUTHOR(S)

* David A. Golden <dagolden@cpan.org>
* J.R. Mash <jrmash@cpan.org>

# CONTRIBUTOR(S)

* Jaryd Malbin <jaryd@duckduckgo.com>

# MAINTAINER(S)

* Zak B. Elep <zakame@cpan.org>

# COPYRIGHT & LICENSE

Copyright (c) 2012-2020, the above named AUTHORS, CONTRIBUTORS, and MAINTAINERS

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
