name        'base_role'
description 'top level attributes, applies to all nodes'

run_list(*%w[
  cluster_chef::node_name

  build-essential
  ubuntu
  motd

  users
])

#
# Attributes applied if the node doesn't have it set already.
# Override the active_users attribute in the role (gibbon_cluster, etc) if
# necessary
#
default_attributes({
    :active_users => [ "flip"],
    :authorization => { :sudo => { :groups => ['admin'], :users => ['ubuntu'] } },
    :groups => {
      'flip'          => { :gid => 1001, },
      #
      'deploy'        => { :gid => 2000, },
      #
      'admin'         => { :gid =>  200, },
      'sudo'          => { :gid =>  201, },
      #
      'hadoop'        => { :gid =>  300, },
      'supergroup'    => { :gid =>  301, },
      'hdfs'          => { :gid =>  302, },
      'mapred'        => { :gid =>  303, },
      'hbase'         => { :gid =>  304, },
      'zookeeper'     => { :gid =>  305, },
      #
      'cassandra'     => { :gid =>  330, },
      'databases'     => { :gid =>  331, },
      'azkaban'       => { :gid =>  332, },
      'redis'         => { :gid =>  335, },
      'memcached'     => { :gid =>  337, },
      'jenkins'       => { :gid =>  360, },
      'elasticsearch' => { :gid =>  61021, },
      #
      'webservers'    => { :gid =>  401, },
      'nginx'         => { :gid =>  402, },
      'scraper'       => { :gid =>  421, },
    },

    #
    # Want your password auto-set? Run `mkpasswd -m sha-512`, type in your password when prompted (it will not echo to the screen). Paste the magic gobbledygook into the :password => '' part, below:
    #
    :users => {
      'flip'          => { :uid => 1001, :groups => %w[ flip      admin sudo supergroup ], :comment => "Philip (flip) Kromer", :password => '$6$vS/sJmmI$aorlnWkRJgeh02lvCpZLnDDBEUWUSalHJUL520nl/u2yo1F.DhtXcFKpOgwm1n58cS9yr3Xj.mzeZipubyJ4F/', :shell => '/bin/bash' }, #
      #
      'deploy'        => { :uid => 2000, :groups => %w[ deploy    admin sudo www-data   ], :comment => "For Capistrano"      ,       :shell => '/bin/false', },
      #
      'hdfs'          => { :uid =>  302, :groups => %w[ hdfs      hadoop                ], :comment => "Hadoop HDFS User",           :shell => '/bin/false', },
      'mapred'        => { :uid =>  303, :groups => %w[ mapred    hadoop                ], :comment => "Hadoop Mapred Runner",       :shell => '/bin/false', },
      'hbase'         => { :uid =>  304, :groups => %w[ hbase                           ], :comment => "Hadoop HBase Daemon",        :shell => '/bin/false', },
      'zookeeper'     => { :uid =>  305, :groups => %w[ zookeeper                       ], :comment => "Hadoop Zookeeper Daemon",    :shell => '/bin/false', },
      #
      'cassandra'     => { :uid =>  330, :groups => %w[           databases             ], :comment => "Cassandra db",               :shell => '/bin/false', },
      'azkaban'       => { :uid =>  332, :groups => %w[                                 ], :comment => "Azkaban runner",             :shell => '/bin/false', },
      'redis'         => { :uid =>  335, :groups => %w[ redis     databases             ], :comment => "Redis-server runner",        :shell => '/bin/false', },
      'memcached'     => { :uid =>  337, :groups => %w[           databases             ], :comment => "Memcached/Starling runner",  :shell => '/bin/false', },
      'jenkins'       => { :uid =>  360, :groups => %w[ jenkins                         ], :comment => "Jenkins server user",        :shell => '/bin/false', },
      'jenkins-node'  => { :uid =>  361, :groups => %w[ jenkins                         ], :comment => "Jenkins worker user",        :shell => '/bin/false', },
      'elasticsearch' => { :uid =>61021, :groups => %w[ elasticsearch                   ], :comment => "Elasticsearch",              :shell => '/bin/false', },
      #
      'www-data'      => { :uid =>   33, :groups => %w[           webservers www-data   ], :comment => "Runs the web server ",       :shell => '/bin/false', },
      'nginx'         => { :uid =>  402, :groups => %w[ nginx     webservers www-data   ], :comment => "",                           :shell => '/bin/false', },
    },
  })
