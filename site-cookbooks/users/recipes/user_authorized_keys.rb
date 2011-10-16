# Creates the ubuntu user.

active_users = []
active_users += node[:active_users] if node[:active_users]
active_users += node[:extra_users] if node[:extra_users]


active_users.each do |uname|
  template "/home/#{uname}/.ssh/authorized_keys" do
    owner uname
    group uname
    mode "0600"
    variables( :keys => [ [uname,node[:users][uname][:public_key] ] ] )
    not_if "test -f /home/#{uname}/.ssh/authorized_keys"
  end if node[:users][uname] && node[:users][uname][:public_key]
end


