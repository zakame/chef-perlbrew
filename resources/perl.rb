#
# Author:: David A. Golden
# Cookbook:: perlbrew
# Resource:: perlbrew_perl
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

property :version, String, name_property: true
property :install_options, String
property :installed, [true, false], default: false

load_current_value do
  installed ::File.exist?("#{node['perlbrew']['perlbrew_root']}/perls/#{name}")
end

action :install do
  unless new_resource.installed
    new_resource.version(new_resource.name) unless new_resource.version
    new_resource.install_options(node['perlbrew']['install_options']) unless new_resource.install_options

    execute "Install perlbrew perl #{new_resource.name}" do
      environment('PERLBREW_ROOT' => node['perlbrew']['perlbrew_root'])
      command "#{node['perlbrew']['perlbrew_root']}/bin/perlbrew install #{new_resource.version} --as #{new_resource.name} #{new_resource.install_options}"
      creates "#{node['perlbrew']['perlbrew_root']}/perls/#{new_resource.name}"
    end
  end
end

action :remove do
  if new_resource.installed
    execute "Remove perlbrew perl #{new_resource.name}" do
      environment('PERLBREW_ROOT' => node['perlbrew']['perlbrew_root'])
      command "#{node['perlbrew']['perlbrew_root']}/bin/perlbrew uninstall #{new_resource.name}"
    end
  end
end
