gem_package 'ruby-shadow'
package     'makepasswd'

node[:groups].each do |group_key, config|
  group group_key do
    group_name group_key.to_s
    gid        config[:gid]
    action     [:create ]
    append     true
  end
end

active_users = []
active_users += node[:active_users] if node[:active_users]
active_users += node[:extra_users] if node[:extra_users]
puts active_users.inspect

if active_users.length > 0
  active_users.each do |uname|
    config = node[:users][uname] or next
    user_main_group = config[:groups].first.to_s

    group user_main_group do
      action  [:create]
      not_if{ node[:etc][:group][user_main_group] }
    end

    user uname do
      comment   config[:comment]
      uid       config[:uid]
      gid       user_main_group
      home      "/home/#{uname}"
      shell     config[:shell] || "/bin/bash"
      password  config[:password] unless config[:password].nil?
      supports  :manage_home => true
      action    [:create, :manage]
    end

    directory "/home/#{uname}/.ssh" do
      action    :create
      owner     uname
      group     config[:groups].first.to_s
      mode      0700
      only_if{  File.exists?("/home/#{uname}") }
    end

    config[:groups].each do |gname|
      group gname do
        group_name gname.to_s
        members    [ uname ]
        append     true
        action     [ :create, :modify, :manage ]
      end
    end

  end
end
