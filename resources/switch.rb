#
# Author:: J.R. Mash
# Cookbook Name:: perlbrew
# Resource:: perlbrew_switch
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

resource_name :perlbrew_switch

property :version, String, name_property: true
property :root, String, default: node['perlbrew']['perlbrew_root']

action :default do
  cmd = 'switch'
  if new_resource.version =~ /^off$/i
    cmd.concat('-off')
  else
    cmd.concat(" #{new_resource.version}")
  end

  bash "perlbrew #{cmd}" do
    environment(
      'PERLBREW_ROOT' => new_resource.root,
      'PERLBREW_HOME' => new_resource.root,
    )
    code <<-EOC
    source #{new_resource.root}/etc/bashrc
    perlbrew #{cmd}
    EOC
    only_if { ::File.exist?("#{new_resource.root}/bin/perlbrew") }
  end
end
