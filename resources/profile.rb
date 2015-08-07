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
actions :install, :remove
default_action :install

attribute :script,      :kind_of => String,             :name_attribute => true

attribute :group,       :kind_of => String,             :default => node['perlbrew']['profile']['group']
attribute :mode,        :kind_of => [Integer, String],  :default => node['perlbrew']['profile']['mode']
attribute :owner,       :kind_of => String,             :default => node['perlbrew']['profile']['owner']
attribute :template,    :kind_of => String,             :default => node['perlbrew']['profile']['template']
