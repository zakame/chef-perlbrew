#
# Author:: J.R. Mash
# Contributors:: Jaryd Malbin <jaryd@duckduckgo.com>
# Cookbook Name:: perlbrew
# Resource:: perlbrew_profile
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

resource_name :perlbrew_profile

property :script, String, name_property: true
property :group, String, default: node['perlbrew']['profile']['group']
property :mode, [Integer, String], default: node['perlbrew']['profile']['mode']
property :owner, String, default: node['perlbrew']['profile']['owner']
property :template, String, default: node['perlbrew']['profile']['template']
property :cookbook, String, default: 'perlbrew'

action :install do
  template new_resource.name do
    source new_resource.template
    cookbook new_resource.cookbook
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
  end
end

action :remove do
  file new_resource.script do
    action :delete
  end
end
