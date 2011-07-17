ClusterChef.cluster 'demosimple' do
  mounts_ephemeral_volumes
  setup_role_implications

  cloud do
    backing             "ebs"
    image_name          "maverick"
    flavor              "t1.micro"
    availability_zones  ['us-east-1a']
    bootstrap_distro    'ubuntu10.04-cluster_chef'
  end

  role                  :base_role
  role                  :chef_client
  role                  :ssh

  cluster_role do
    run_list(*%w[])
    override_attributes({
        :ruby => { :version => '1.9.1' }, # yes 1.9.1 means 1.9.2
      })
  end

  facet :homebase do
    instances           1
    role                :nfs_server

    facet_role do
      run_list(*%w[
        role[big_package]
      ])
    end
  end
end
