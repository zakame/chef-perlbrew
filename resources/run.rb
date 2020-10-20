#
# Author:: David A. Golden
# Cookbook:: perlbrew
# Resource:: perlbrew_run
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

property :command, String, name_property: true
property :perlbrew, String, required: true
property :cwd, String
property :environment, Hash, default: {}

action :run do
  perlbrew_env = {
    'PERLBREW_ROOT' => node['perlbrew']['perlbrew_root'],
    'PERLBREW_HOME' => node['perlbrew']['perlbrew_root'],
    'PERL_CPANM_HOME' => "#{Chef::Config[:file_cache_path]}/cpanm",
  }
  bash new_resource.name do
    environment new_resource.environment.merge(perlbrew_env)
    cwd new_resource.cwd if new_resource.cwd
    code <<-EOC
    source #{node['perlbrew']['perlbrew_root']}/etc/bashrc
    perlbrew use #{new_resource.perlbrew}
    #{new_resource.command}
    EOC
  end
end
