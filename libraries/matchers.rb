#
# Author:: J.R. Mash
# Cookbook Name:: perlbrew
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
if defined?(ChefSpec)
  
  def perlbrew_install(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:perlbrew, :install, resource_name)
  end
  def perlbrew_remove(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:perlbrew, :remove, resource_name)
  end
  
  def perlbrew_cpanm_install(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:perlbrew_cpanm, :install, resource_name)
  end
  def perlbrew_cpanm_run(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:perlbrew_cpanm, :run, resource_name)
  end
  
  def perlbrew_lib_create(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:perlbrew_lib, :create, resource_name)
  end
  def perlbrew_lib_remove(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:perlbrew_lib, :delete, resource_name)
  end
  
  def perlbrew_perl_install(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:perlbrew_perl, :install, resource_name)
  end
  def perlbrew_perl_remove(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:perlbrew_perl, :remove, resource_name)
  end
  
  def perlbrew_profile_install(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:perlbrew_profile, :install, resource_name)
  end
  def perlbrew_profile_remove(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:perlbrew_profile, :remove, resource_name)
  end
  
  def perlbrew_run(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:perlbrew_run, :run, resource_name)
  end
  
  def perlbrew_switch(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:perlbrew_switch, :default, resource_name)
  end
  
end
