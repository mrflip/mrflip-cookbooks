#
# Author:: Doug MacEachern <dougm@vmware.com>
# Cookbook Name:: jenkins
# Recipe:: default
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

user node[:jenkins][:server][:user] do
  home      node[:jenkins][:server][:home]
end

directory node[:jenkins][:server][:home] do
  recursive true
  owner     node[:jenkins][:server][:user]
  group     node[:jenkins][:server][:group]
end

directory "#{node[:jenkins][:server][:home]}/plugins" do
  owner     node[:jenkins][:server][:user]
  group     node[:jenkins][:server][:group]
  not_if{   node[:jenkins][:server][:plugins].empty? }
end

node[:jenkins][:server][:plugins].each do |name|
  remote_file "#{node[:jenkins][:server][:home]}/plugins/#{name}.hpi" do
    source  "#{node[:jenkins][:plugins_mirror]}/latest/#{name}.hpi"
    backup  false
    owner   node[:jenkins][:server][:user]
    group   node[:jenkins][:server][:group]
  end
end

# See http://jenkins-ci.org/debian/
package_provider       = Chef::Provider::Package::Dpkg
pid_file               = "/var/run/jenkins/jenkins.pid"
install_starts_service = true
apt_key                = "/tmp/jenkins-ci.org.key"

remote_file apt_key do
  source "#{node[:jenkins][:apt_mirror]}/jenkins-ci.org.key"
  action :create
end

execute "add-jenkins_repo-key" do
  command %Q{echo "Adding jenkins apt repo key" ; apt-key add #{apt_key}}
  action :nothing
end

file "/etc/apt/sources.list.d/jenkins.list" do
  owner   "root"
  group   "root"
  mode    0644
  content "deb #{node[:jenkins][:apt_mirror]} binary/\n"
  action  :create
  notifies :run, "execute[add-jenkins_repo-key]",        :immediately
  notifies :run, resources(:execute => "apt-get update"), :immediately
end

service "jenkins" do
  supports [ :stop, :start, :restart, :status ]
  # # "jenkins status" will exit(0) even when the process is not running
  # status_command "test -f #{pid_file} && kill -0 `cat #{pid_file}`"
  action :nothing
end
provide_service('jenkins_server', :port => node[:jenkins][:server][:port])

template '/etc/default/jenkins' do
  source    'etc-default-jenkins.erb'
  mode      "0644"
  action    :create
  notifies  :restart,  "service[jenkins]"
end

# Install jenkins
package "daemon"
package "jenkins"

# restart if this run only added new plugins
log "plugins updated, restarting jenkins" do
  # ugh :restart does not work, need to sleep after stop.
  notifies :restart,  "service[jenkins]"
  only_if do
    if File.exists?(pid_file)
      htime = File.mtime(pid_file)
      Dir["#{node[:jenkins][:server][:home]}/plugins/*.hpi"].select { |file|
        File.mtime(file) > htime
      }.size > 0
    end
  end
end

