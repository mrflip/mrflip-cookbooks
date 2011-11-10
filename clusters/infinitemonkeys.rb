ClusterChef.cluster 'infinitemonkeys' do
  cloud(:ec2) do
    defaults
    availability_zones ['us-east-1d']
    image_name          'mrflip-natty'
    bootstrap_distro    'ubuntu10.04-cluster_chef'
    chef_client_script  'client-v3.rb'
    mount_ephemerals
  end

  role                  :base_role
  role                  :chef_client
  role                  :ssh
  role                  :mountable_volumes

  role                  :mrflip_base
  # role                  :infochimps_base

  #
  # An NFS server to hold your home drives.
  #
  # It's stop-start'able, but if you're going to use this long-term, you should
  # consider creating a separate EBS volume to hold /home
  #
  facet :homebase do
    instances           1
    role                :nfs_server

    volume(:home) do
      defaults
      size                15
      device              '/dev/sdh' # note: will appear as /dev/xvdi on natty
      mount_point         '/home'
      attachable          :ebs
      # snapshot_id       '' # 200gb xfs
      tags                :home => '/home'
      create_at_launch    true # if no volume is tagged for that node, it will be created
    end
  end

  #
  # A throwaway facet for development.
  #
  facet :sandbox do
    instances           2
    role                :nfs_client
  end

  cluster_role.override_attributes( :mountable_volumes => { :aws_credential_source => 'node_attributes', })
end
