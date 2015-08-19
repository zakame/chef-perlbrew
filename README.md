[![Cookbook](https://img.shields.io/cookbook/v/perlbrew.svg)](https://community.opscode.com/cookbooks/perlbrew)
[![Dependencies](https://gemnasium.com/jrmash/perlbrew.svg)](https://gemnasium.com/jrmash/perlbrew)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)

DESCRIPTION
-----------
This cookbook provides resource primitives (LWRPs) and recipes that can be used
to configure, install, and manage the Perlbrew environment.

PLATFORMS
---------
This cookbook is tested on the following platforms:

* CentOS/RHEL 5.11 64-bit
* CentOS/RHEL 6.6 64-bit
* Debian 6.0.10
* Debian 7.8
* Ubuntu 10.04
* Ubuntu 12.04
* Ubuntu 14.04

Unlisted platforms in the same family, of similar or equivalent versions may work
with or without modification to this cookbook.  Pull requests to add support for
other platforms are welcome.

REQUIREMENTS
------------
Perlbrew requires a system perl and the following packages to be available during
the installation process:

* curl
* patch

Perlbrew compiles perl from source and requires a standard compiler toolchain to
be available.  The bundled 'perlbrew' recipe installs this toolchain automatically
using the [build-essential](https://github.com/opscode-cookbooks/build-essential) cookbook, if they are missing.  The LWRP method of
configuring and installing perlbrew defers this responsibility to the cookbook
consumer.

ATTRIBUTES
----------
* `node['perlbrew']['perlbrew_root'] = "/opt/perlbrew"` - Sets the `PERLBREW_ROOT` environment variable
* `node['perlbrew']['perls'] = []` - An array of perls to install, e.g. `["perl-5.14.2", "perl-5.12.3"]`
* `node['perlbrew']['install_options'] = ''` - A string of command line options for `perlbrew install`, e.g. `-D usethreads` for building all perls with threads
* `node['perlbrew']['cpanm_options'] = ''` - A string of command line options for `cpanm`, e.g. `--notest` for installing modules without running tests
* `node['perlbrew']['self_upgrade'] = true` - Set to false if you don't want perlbrew upgraded to the latest version automatically

RECIPES
-------
###perlbrew
Installs/updates perlbrew along with patchperl and cpanm.  This is required for
use of the LWRP.  Optionally installs perls specified in the
`node['perlbrew']['perls']` attribute list.

###perlbrew::profile
This recipe installs a file in `/etc/profile.d` that enables perlbrew for all
users, though the standard caveats mentioned in the perlbrew documentation do
apply.

RESOURCES / PROVIDERS
---------------------
###perlbrew
This LWRP provides actions to install / remove perlbrew using the directory
specified in the `node['perlbrew']['perlbrew_root']` attribute.

* ####Actions
  * ***:install (default)***

            perlbrew '/opt/perlbrew' do
              perls         [ 'perl-5.10.1', 'perl-5.14.2' ]
              upgrade       true
            end

  * ***:remove***
    
            perlbrew '/opt/perlbrew' do
              action        :remove
            end

* ####Attributes
  * :perls - An array of strings representing perls to brew / install.
  * :upgrade - A boolean flag to disable/enable the automatic upgrading of perlbrew. 

###perlbrew_profile
This LWRP provides actions to install / remove the shell script that enables
perlbrew for all users.

* ####Actions
  * ***:install (default)***

            perlbrew_profile '/etc/profile.d/perlbrew.sh' do
	          mode          0644
    	      group         'root'
              owner         'root'
	          template      'perlbrew.sh.erb'
            end

  * #####:remove
    
            perlbrew_profile '/etc/profile.d/perlbrew.sh' do
              action        :remove
            end

* ####Attributes
  * :mode - The file's default permissions.
  * :group - The file's group association.
  * :owner - The file's owner.
  * :template - The template used to create the file.

###perlbrew_perl
This LWRP provides actions to brew and install perls into `node['perlbrew']['perlbrew_root']`.

* ####Actions
  * ***:install (default)***

            ## Equivalent to 'perlbrew install perl-5.14.2'
            perlbrew_perl 'perl-5.14.2' do
              action :install
            end

            ## Equivalent to 'perlbrew install perl-5.14.2 --as 5.14.2'
            perlbrew_perl '5.14.2' do
              version 'perl-5.14.2'
              action :install
            end
  
  * ***:remove***
   
            perlbrew_perl 'perl-5.14.2' do
              action :remove
            end

* ####Attributes
  * :install_options - The options to be provided during brewing / installation.
  * :version - The version of perl to install, in the `perl-X.Y.Z` format that perlbrew expects.

###perlbrew_switch
This LWRP provides an action to switch between brewed perl installations / system perl.

* ####Actions
  * ***:default (default)***

            perlbrew_switch 'off'
            perlbrew_switch 'perl-5.14.2'

###perlbrew_lib
This LWRP creates a perlbrew-based local::lib library for a particular perlbrew
perl.

* ####Actions
  * ***:create (default)***

            perlbrew_lib 'perl-5.14.2@mylib' do
              action :create
            end

  * ***:delete***

            perlbrew_lib 'perl-5.14.2@mylib' do
              action :delete
            end

* ####Attributes
  * :perlbrew - The brewed perl to attach the library to (e.g. perl-5.14.2), and it is not
     installed, the `perlbrew_perl` LWRP will be used to brew and install it.  If this 
     attribute is not specified, it will be derived from the `perlbrew_lib` name.

###perlbrew_cpanm
This LWRP installs CPAN modules to a given perlbrew perl or local::lib using
cpanm (App::cpanminus).

* ####Actions
  * ***:install (default)***

            perlbrew_cpanm 'Modern Perl modules' do
              modules ['Modern::Perl', 'Task::Kensho']
              perlbrew 'perl-5.14.2@mylib'
            end

* ####Attributes
  * :modules - The list of module names to pass to `cpanm`.
  * :perlbrew - The brewed perl (and optional library) to use for installing modules.

###perlbrew_run
This LWRP runs a bash command in the context of a given perlbrew perl or local::lib.

* ####Actions
  * ***:run (default)***

            ##Execute as script file.
            perlbrew_run 'hello-world.pl' do
               perlbrew 'perl-5.14.2@mylib'
            end

            ## Execute as a script string.
            perlbrew_run 'Perl hello world' do
              perlbrew 'perl-5.14.2@mylib'
              command "perl -wE 'say q{Hello World}'"
            end

* ####Attributes
  * :command - The bash command to run, defaulting to the resource name if not
               specified.
  * :cwd - The directory to change into prior to running the command.
  * :environment - The hash of environment variables to set prior to running the
                   command
  * :perlbrew - The brewed perl (and optional library) to use for running the command.

USAGE
-----
This cookbook provides the following methods for configuring and installing
perlbrew, one of which is required to use the other LWRPs in the cookbook:

    ## Method 1 - Include this cookbook's recipes in your cookbook/recipe: 
    include_recipe 'perlbrew'
    include_recipe 'perlbrew::profile'

    ## Method 2 - Use this cookbook's LWRPs in your cookbook/recipe:
    perlbrew <path> do
      perls         [ <perl-version>, <perl-version> ]
      upgrade       <true|false>
    end
    perlbrew_profile <path> do
      group         <group-name>
      owner         <owner-name>
      mode          <mode>
      template      <template-file>
    end


AUTHOR(S)
---------
* David A. Golden <dagolden@cpan.org>
* J.R. Mash <jrmash@cpan.org>

CONTRIBUTOR(S)
--------------
* Jaryd Malbin <jaryd@duckduckgo.com>

MAINTAINER(S)
-------------
* J.R. Mash <jrmash@cpan.org>

COPYRIGHT & LICENSE
-------------------
```text
Copyright (c) 2012-2015, the above named AUTHORS, CONTRIBUTORS, and MAINTIANERS

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
