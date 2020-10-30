#
# Author:: J.R. Mash
# Cookbook:: perlbrew
# Resource:: default (perlbrew)
#
# Copyright:: 2015, J.R. Mash <jrmash@cpan.org>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

resource_name :perlbrew
provides :perlbrew

property :root, String, name_property: true

property :perls, Array, default: node['perlbrew']['perls']
property :upgrade, [true, false], default: node['perlbrew']['self_upgrade']

action :install do
  %w( curl gcc make patch perl ).each do |p|
    package p
  end

  perlbrew_root = new_resource.root
  perlbrew_bin = "#{perlbrew_root}/bin/perlbrew"

  # use a known release version of the installer and save its checksum
  # here for verifying later during install
  perlbrew_install = 'https://raw.githubusercontent.com/gugod/App-perlbrew/release-0.89/perlbrew-install'
  perlbrew_install_sha256 = 'c3996e4fae37a0ae01839cdd73752fb7b17e81bac2a8b39712463a7d518c4945'

  directory perlbrew_root

  # start a resource to install cpanm if needed later
  bash 'perlbrew install-cpanm' do
    environment('PERLBREW_ROOT' => perlbrew_root)
    code "#{perlbrew_bin} -f install-cpanm"
    action :nothing
  end

  # if we have perlbrew, upgrade it
  bash "perlbrew self-upgrade (#{new_resource.name})" do
    environment('PERLBREW_ROOT' => perlbrew_root)
    code <<-EOC
    #{perlbrew_bin} self-upgrade
    #{perlbrew_bin} -f install-patchperl
    EOC
    only_if { ::File.exist?(perlbrew_bin) && new_resource.upgrade }
    notifies :run, 'bash[perlbrew install-cpanm]', :immediately
  end

  # if not, install it
  unless ::File.exist?(perlbrew_bin)
    remote_file "#{Chef::Config[:file_cache_path]}/perlbrew-install" do
      source perlbrew_install
      checksum perlbrew_install_sha256
      owner 'root'
      group 'root'
      mode '0755'
    end
    bash 'perlbrew-install' do
      environment('PERLBREW_ROOT' => perlbrew_root)
      code "#{Chef::Config[:file_cache_path]}/perlbrew-install"
      notifies :run, 'bash[perlbrew install-cpanm]', :immediately
    end
  end

  # were any perls requested in attributes?
  new_resource.perls.each do |p|
    perlbrew_perl p
  end
end

action :remove do
  directory new_resource.root do
    action :delete
    recursive true
  end
end
