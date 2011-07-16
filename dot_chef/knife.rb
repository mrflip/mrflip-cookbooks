current_dir = File.dirname(__FILE__)
organization  = 'mrflip'
username      = 'mrflip'

# The full path to your cluster_chef installation
cluster_chef_path File.expand_path("#{current_dir}/../cluster_chef")
# The directory holding your cloud keypairs
keypair_path      File.expand_path(current_dir)

log_level                :info
log_location             STDOUT
node_name                username
client_key               "#{keypair_path}/#{username}.pem"
validation_client_name   "#{organization}-validator"
validation_key           "#{keypair_path}/#{organization}-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/#{organization}"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )

cookbook_path            [
  "#{current_dir}/../cookbooks",
  "#{current_dir}/../site-cookbooks",
  "#{cluster_chef_path}/cookbooks",
]

# AWS access credentials
load "#{current_dir}/#{username}-awskeys.rb"
