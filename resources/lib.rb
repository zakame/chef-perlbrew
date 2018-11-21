#
# Author:: David A. Golden
# Cookbook Name:: perlbrew
# Resource:: perlbrew_lib
#
# Copyright:: 2012, David A. Golden <dagolden@cpan.org>
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

resource_name :perlbrew_lib

property :lib, String, name_property: true
property :perlbrew, String

action :create do
  new_resource.perlbrew(new_resource.lib[/[^@]+/]) unless new_resource.perlbrew
  perlbrew_perl new_resource.perlbrew do
    not_if { ::File.exist?("#{node['perlbrew']['perlbrew_root']}/perls/#{new_resource.perlbrew}") }
  end
  execute "Create perlbrew lib #{new_resource.lib}" do
    environment(
      'PERLBREW_ROOT' => node['perlbrew']['perlbrew_root'],
      'PERLBREW_HOME' => node['perlbrew']['perlbrew_root'],
    )
    command "#{node['perlbrew']['perlbrew_root']}/bin/perlbrew lib create #{new_resource.lib}"
    not_if { ::File.exist?("#{node['perlbrew']['perlbrew_root']}/libs/#{new_resource.lib}") }
  end
end

action :delete do
  execute "Remove perlbrew #{new_resource.lib}" do
    environment(
      'PERLBREW_ROOT' => node['perlbrew']['perlbrew_root'],
      'PERLBREW_HOME' => node['perlbrew']['perlbrew_root'],
    )
    command "#{node['perlbrew']['perlbrew_root']}/bin/perlbrew lib delete #{new_resource.lib}"
    only_if { ::File.exist?("#{node['perlbrew']['perlbrew_root']}/libs/#{new_resource.lib}") }
  end
end
