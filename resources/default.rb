#
# Author:: J.R. Mash
# Cookbook Name:: perlbrew
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

property :root, String, name_property: true

property :perls, Array, default: node['perlbrew']['perls']
property :upgrade, [true, false], default: node['perlbrew']['self_upgrade']

action :install do
  %w( patch perl curl ).each do |p|
    package p
  end

  perlbrew_root = new_resource.root
  perlbrew_bin = "#{perlbrew_root}/bin/perlbrew"

  # use a known release version of the installer and save its checksum
  # here for verifying later during install
  perlbrew_install = 'https://raw.githubusercontent.com/gugod/App-perlbrew/release-0.86/perlbrew-install'
  perlbrew_install_sha256 = '29bb40292e786336a58ace7b9db4d8dc9ad5ace3f3cb35d9978caddac2eba12c'

  directory perlbrew_root

  # if we have perlbrew, upgrade it
  bash "perlbrew self-upgrade (#{new_resource.name})" do
    environment('PERLBREW_ROOT' => perlbrew_root)
    code <<-EOC
    #{perlbrew_bin} self-upgrade
    #{perlbrew_bin} -f install-patchperl
    #{perlbrew_bin} -f install-cpanm
    EOC
    only_if { ::File.exist?(perlbrew_bin) && new_resource.upgrade }
  end

  # if not, install it
  bash 'perlbrew-install' do
    cwd Chef::Config[:file_cache_path]
    environment('PERLBREW_ROOT' => perlbrew_root)
    code <<-EOC
    curl -fsSL #{perlbrew_install} > ./perlbrew-install
    echo '#{perlbrew_install_sha256} *perlbrew-install' | sha256sum -c -
    bash ./perlbrew-install
    #{perlbrew_root}/bin/perlbrew -f install-cpanm
    rm ./perlbrew-install
    EOC
    not_if { ::File.exist?(perlbrew_bin) }
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
