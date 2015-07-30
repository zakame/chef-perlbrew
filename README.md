Description
===========
This cookbook provides resource primitives (LWRPs) and recipes that can be used
to configure, install, and manage the Perlbrew environment.

Platforms
=========
To date, this cookbook has been developed and tested on the following platforms:
* Ubuntu
* Debian
* CentOS 5/6
* Amazon Linux

Requirements
============
Perlbrew requires a system perl and the following packages to be available during
the installation process:

* curl
* patch

Perlbrew compiles perl from source and requires a standard compiler toolchain to
be available.  The bundled 'perlbrew' recipe installs this toolchain automatically
using the [build-essential](https://github.com/opscode-cookbooks/build-essential) cookbook, if they are missing.  The LWRP method of
configuring and installing perlbrew defers this responsibility to the cookbook
consumer.

Attributes
==========

* `node['perlbrew']['perlbrew_root'] = "/opt/perlbrew"` - Sets the `PERLBREW_ROOT` environment variable
* `node['perlbrew']['perls'] = []` - An array of perls to install, e.g. `["perl-5.14.2", "perl-5.12.3"]`
* `node['perlbrew']['install_options'] = ''` - A string of command line options for `perlbrew install`, e.g. `-D usethreads` for building all perls with threads
* `node['perlbrew']['cpanm_options'] = ''` - A string of command line options for `cpanm`, e.g. `--notest` for installing modules without running tests
* `node['perlbrew']['self_upgrade'] = true` - Set to false if you don't want perlbrew upgraded to the latest version automatically

Recipes
=======

perlbrew
----------

Installs/updates perlbrew along with patchperl and cpanm.  This is required for
use of the LWRP.  Optionally installs perls specified in the
`node['perlbrew']['perls']` attribute list.

perlbrew::profile
-----------------
This recipe installs a file in `/etc/profile.d` that enables perlbrew for all
users, though the standard caveats mentioned in the perlbrew documentation do
apply.

Resources/Providers
===================
perlbrew
--------
This LWRP provides actions to install / remove perlbrew using the directory
specified in the `node['perlbrew']['perlbrew_root']` attribute.
###Actions
####:install
    perlbrew node['perlbrew']['perlbrew_root'] do
      perls         node['perlbrew']['perls']
      upgrade       node['perlbrew']['self_upgrade']
    end
####:remove
    perlbrew node['perlbrew']['perlbrew_root'] do
      action        :remove
    end

perlbrew_profile
----------------

This LWRP provides actions to install / remove the shell script that enables
perlbrew for all users.
###Actions
####:install
    perlbrew_profile node['perlbrew']['profile']['script'] do
	  group         node['perlbrew']['profile']['group']
	  owner         node['perlbrew']['profile']['owner']
	  mode          node['perlbrew']['profile']['mode']
	  template      node['perlbrew']['profile']['template']
    end
####:remove
    perlbrew_profile node['perlbrew']['profile']['path'] do
      action        :remove
    end

perlbrew_perl
-------------

This LWRP installs perls into `node['perlbrew']['perlbrew_root']` using
perlbrew.

    # option 1
    perlbrew_perl perl-VERSION do
      action :install
    end

    # option 2
    perlbrew_perl NICKNAME do
      version perl-VERSION
      action :install
    end

Example:

    perlbrew_perl '5.14.2' do
      version 'perl-5.14.2'
      action :install
    end

This is equivalent to `perlbrew install perl-5.14.2 --as 5.14.2`.

Actions:

* :install - install the specified perl (default action)
* :remove - uninstall the specified perl

Attributes:

* :version - the version of perl to install, in the "perl-X.Y.Z" format that perlbrew expects
This is based on the perlbrew_perl name if not provided.
* :install_options - overrides the default install options on the node. (Not recommended.)

perlbrew_lib
------------

This LWRP creates a perlbrew-based local::lib library for a particular perlbrew
perl.

Example:

    perlbrew_lib 'perl-5.14.2@mylib' do
      action :create
    end

This is equivalent to `perlbrew lib create perl-5.14.2@mylib`

Action:

* :create - creates the local::lib (default action)
* :delete - removes the local::lib

Attributes:

* :perlbrew - the perlbrew perl to attach the library to (e.g. 'perl-5.14.2').
It will be derived from the perlbrew_lib name if not provided.  The
perlbrew perl will be installed using the perlbrew_perl LRWP if it has not already
been installed.

perlbrew_cpanm
--------------

This LWRP installs CPAN modules to a given perlbrew perl or local::lib using
cpanm (App::cpanminus).

Example:

    perlbrew_cpanm 'Modern Perl modules' do
      perlbrew 'perl-5.14.2@mylib'
      modules ['Modern::Perl', 'Task::Kensho']
    end

This is equivalent to

    $ perlbrew use perl-5.14.2@mylib
    $ cpanm Modern::Perl Task::Kensho

Note that the resource name "Modern Perl modules" will be associated with a set of
modules only once.  The name should be unique for any particular chef run.

Action:

* :install - install the list of modules (default action) 

Attributes:

* :perlbrew - the perlbrew perl (and optional library) to use for installing
modules (REQUIRED)
* :modules - an array of module names to pass to cpanm.  Any legal input
to cpanm is allowed.
* :options - a string of options to pass to cpanm.  Any legal options to
cpanm is allowed.

perlbrew_run
------------

This LWRP runs a bash command in the context of a given perlbrew perl or local::lib.

Example 1:

    perlbrew_run 'Perl hello world' do
      perlbrew 'perl-5.14.2@mylib'
      command "perl -wE 'say q{Hello World}'"
    end

This is equivalent to

    $ perlbrew use perl-5.14.2@mylib
    $ perl -wE 'say q{Hello World}'

Example 2:

    perlbrew_run 'hello-world.pl' do
      perlbrew 'perl-5.14.2@mylib'
    end

This is equivalent to

    $ perlbrew use perl-5.14.2@mylib
    $ hello-world.pl

Note that the resource name will only be executed once for a given chef run.

Action:

* :run - runs the command (default action) 

Attributes:

* :perlbrew - the perlbrew perl (and optional library) to be enabled prior
to running the command (REQUIRED)
* :command - the bash command to run; taken from the resource name if not
provided
* :cwd - directory to enter prior to running the command, just like the `bash`
resource attribute
* :environment - hash of environment variables to set prior to running the
command, just like the `bash` resource attribute

Usage
=====

This cookbook provides the following methods for configuring and installing
perlbrew, one of which is required to use the other LWRPs in the cookbook:

###Method 1 - Include this cookbook's recipes in your cookbook/recipe: 
    include_recipe 'perlbrew'
    include_recipe 'perlbrew::profile'

###Method 2 - Use this cookbook's LWRPs in your cookbook/recipe:
    perlbrew node['perlbrew']['perlbrew_root'] do
      perls         node['perlbrew']['perls']
      upgrade       node['perlbrew']['self_upgrade']
    end
    perlbrew_profile node['perlbrew']['profile']['script'] do
	  group         node['perlbrew']['profile']['group']
	  owner         node['perlbrew']['profile']['owner']
	  mode          node['perlbrew']['profile']['mode']
	  template      node['perlbrew']['profile']['template']
    end
