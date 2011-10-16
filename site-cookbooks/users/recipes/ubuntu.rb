# Creates the ubuntu user.

gem_package "ruby-shadow"

directory "/home_local" do
  owner "root"
  group "root"
  mode "0755"
end

directory "/home_local/ubuntu" do
  owner "ubuntu"
  group "ubuntu"
  mode "0700"
end

directory "/home_local/ubuntu/.ssh" do
  owner "ubuntu"
  group "ubuntu"
  mode "0700"
end

bash "change ubuntu home directory" do
  user "root"
  code %Q{
    usermod --home /home_local/ubuntu ubuntu || echo -e "\n\n *** \n\n Ubuntu user not transplanted!! Are you logged in as ubuntu? \n\n ** \n\n" ;
    true
  }
end


template "/home_local/ubuntu/.ssh/authorized_keys" do
  owner "ubuntu"
  group "ubuntu"
  mode "0600"
  # The authorize
  variables( :keys => [ ["temujin9",node[:users]["temujin9"][:public_key] ] ] )
end

