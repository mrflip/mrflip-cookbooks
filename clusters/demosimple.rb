ClusterChef.cluster 'demosimple' do
  use :defaults
  mounts_ephemeral_volumes
  setup_role_implications

  cloud do
    backing             "ebs"
    image_name          "maverick"
    flavor              "t1.micro"
    availability_zones  ['us-east-1a']
    bootstrap_distro    'ubuntu10.04-cluster_chef'
  end

  cluster_role do
    run_list(*%w[
      role[chef_client]
    ])
  end

  role :ssh

  facet :homebase do
    instances           1
    role :nfs_server
    facet_role do
      run_list(*%w[
       role[nfs_server]
       role[jenkins]
      ])
      # role[resque]
      # role[big_package]
    end
  end

  facet :jobqueue do
    instances           1
    role :nfs_client
    facet_role do
      run_list(*%w[
       role[nfs_client]
       role[jenkins]
      ])
      #
      # role[resque]
      # role[big_package]
    end
  end

end
