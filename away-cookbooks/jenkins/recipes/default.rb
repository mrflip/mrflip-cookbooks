#
# Cookbook Name::       jenkins
# Description::         Installs a Jenkins CI server using the http://jenkins-ci.org/redhat RPM.  The recipe also generates an ssh private key and stores the ssh public key in the node 'jenkins[:pubkey]' attribute for use by the node recipes.
# Recipe::              default
# Author::              Doug MacEachern <dougm@vmware.com>
# Author::              Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2010, VMware, Inc.
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

include_recipe "java::sun"
include_recipe "mountable_volumes"
include_recipe 'jenkins::user_key'

package 'groovy'

if (jenkins_server = provider_for_service(:jenkins_server))
  node[:jenkins][:server][:url]  = "http://#{jenkins_server[:fqdn]}:#{jenkins_server[:jenkins][:server][:port]}"
  node[:jenkins][:server][:port] = jenkins_server[:jenkins][:server][:port]
  node.save
end
