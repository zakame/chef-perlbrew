#
# Author:: J.R. Mash
# Contributors:: Jaryd Malbin <jaryd@duckduckgo.com>
# Cookbook Name:: perlbrew
# Provider:: perlbrew_profile
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
    template new_resource.script do 
        group new_resource.group
        owner new_resource.owner
        mode new_resource.mode
        source new_resource.template
    end
    new_resource.updated_by_last_action(true)
end

action :remove do
    file new_resource.script do
        action :delete
    end
    new_resource.updated_by_last_action(true)
end
