#
# Author:: J.R. Mash
# Contributors:: Jaryd Malbin <jaryd@duckduckgo.com>
# Cookbook Name:: perlbrew
# Provider:: default (perlbrew)
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
action :install do
  %w{ patch perl curl }.each do |p|
    package p
  end
  
  perlbrew_root = new_resource.root
  perlbrew_bin = "#{perlbrew_root}/bin/perlbrew"
  
  directory perlbrew_root
  
  # if we have perlbrew, upgrade it
  bash "perlbrew self-upgrade (#{new_resource.name})" do
    environment ({'PERLBREW_ROOT' => perlbrew_root})
    code <<-EOC
    #{perlbrew_bin} self-upgrade
    #{perlbrew_bin} -f install-patchperl
    #{perlbrew_bin} -f install-cpanm
    EOC
    only_if {::File.exists?(perlbrew_bin) and new_resource.upgrade}
  end
  
  # if not, install it
  bash "perlbrew-install" do
    cwd Chef::Config[:file_cache_path]
    environment ({'PERLBREW_ROOT' => perlbrew_root})
    code <<-EOC
    curl -kL http://install.perlbrew.pl > perlbrew-install
    source perlbrew-install
    #{perlbrew_root}/bin/perlbrew -f install-cpanm
    EOC
    not_if {::File.exists?(perlbrew_bin)}
  end
  
  # were any perls requested in attributes?
  new_resource.perls.each do |p|
    perlbrew_perl p do
      action :install
    end
  end
  new_resource.updated_by_last_action(true)
end

action :remove do
  directory new_resource.root do
    action :delete
    recursive true
  end
  new_resource.updated_by_last_action(true)
end
