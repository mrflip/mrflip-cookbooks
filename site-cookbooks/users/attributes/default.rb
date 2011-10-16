
# We are going to build the list of keypairs to include in the ubuntu user's auth keys
# by combining these attributes :ubuntu_users and :ubuntu_override_users. 
default[:ubuntu_users] = []
default[:ubuntu_override_users] = []
