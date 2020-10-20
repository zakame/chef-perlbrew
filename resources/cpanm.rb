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

property :options, String, default: node['perlbrew']['cpanm_options']
property :perlbrew, String, required: true
property :modules, Array, default: []

action :install do
  perlbrew_run "cpanm #{new_resource.options} #{new_resource.modules.join(' ')}" do
    perlbrew new_resource.perlbrew
  end
end
