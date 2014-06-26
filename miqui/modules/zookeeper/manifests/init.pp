class zookeeper ($serverId) {
  
  include worker_node
  include supervisord::supervisord_zookeeper
  
  group { 'zookeeper':
    ensure => present,
  }
  user { 'zkadmin':
    ensure     => present,
    gid        => 'zookeeper',
    managehome => true,
    home       => '/home/zkadmin',
    shell      => '/bin/bash',
    require    => Group['zookeeper'],
  }
  file { 'zkadmin_home':
    path    => '/home/zkadmin',
    ensure  => directory,
    mode    => '0750',
    owner   => 'zkadmin',
    group   => 'zookeeper',
    require => User['zkadmin'],
  }
  file { 'zoosoftware':
    path    => '/home/zkadmin/software',
    ensure  => directory,
    mode    => '0755',
    owner   => 'zkadmin',
    group   => 'zookeeper',
    require => File['zkadmin_home'],
  }
  file { 'zooruntime':
    path    => '/home/zkadmin/runtime',
    ensure  => directory,
    mode    => '0755',
    owner   => 'zkadmin',
    group   => 'zookeeper',
    require => File['zkadmin_home'],
  }
  file { 'zoobashrc':
    path    => '/home/zkadmin/.bashrc',
    source  => 'puppet:///modules/zookeeper/home/zkadmin/.bashrc',
    mode    => '0644',
    owner   => 'zkadmin',
    group   => 'zookeeper',
    require => File['zkadmin_home'],
  }
  # If zookeeper is always on hadoop nodes and zkadmin is on group hadoop, then it's not necessary this
  file { 'install-java-4zoo':
    path   => '/root/install-java-4zoo.sh',
    source => 'puppet:///modules/zookeeper/root/install-java-4zoo.sh',
    mode   => '0700',
  }
  file { 'install-zookeeper':
    path   => '/root/install-zookeeper.sh',
    source => 'puppet:///modules/zookeeper/root/install-zookeeper.sh',
    mode   => '0700',
  }
  
  exec { 'do-install-java-4zoo':
    command => '/root/install-java-4zoo.sh > /root/java-4zoo-install.log',
    creates => '/root/java-4zoo-installed-by-puppet',
    require => [
      File['install-java-4zoo', 'zoosoftware', 'zooruntime'],
      User['zkadmin'],
      Package['tftp'],
    ],
  }
  exec { 'do-install-zookeeper':
    command => '/root/install-zookeeper.sh > /root/zookeeper-install.log',
    creates => '/root/zookeeper-installed-by-puppet',
    require => [
      File['install-zookeeper', 'zoosoftware', 'zooruntime'],
      User['zkadmin'],
      Package['tftp'],
    ],
  }
  file { 'java-4zoo-installed.flag':
    path => '/root/java-4zoo-installed-by-puppet',
    require => Exec['do-install-java-4zoo'],
  }
  file { 'zookeeper-installed.flag':
    path => '/root/zookeeper-installed-by-puppet',
    require => Exec['do-install-zookeeper'],
  }
  
  service { 'supervisord':
    ensure     => running,
    hasrestart => true,
    enable     => true,
    subscribe  => File['supervisord.conf'],
    require    => [
      File[
        'supervisord.conf',
        'java-4zoo-installed.flag',
        'zookeeper-installed.flag',
        'zookeeper_log'
      ],
      Package['supervisor'],
    ],
  }
  
  file { 'zookeeper_conf_dir':
    path    => '/home/zkadmin/software/zookeeper-3.4.6/conf',
    ensure  => directory,
    mode    => '0755',
    owner   => 'zkadmin',
    group   => 'zookeeper',
    require => File['zookeeper-installed.flag'],
  }
  
  # CONFIG FILES:
  file { 'zoo_configuration.xsl':
    path    => '/home/zkadmin/software/zookeeper-3.4.6/conf/configuration.xsl',
    source  => 'puppet:///modules/zookeeper/3.4.6/conf/configuration.xsl',
    mode    => '0644',
    owner   => 'zkadmin',
    group   => 'zookeeper',
    require => File['zookeeper_conf_dir'],
  }
  file { 'zoo_log4j.properties':
    path    => '/home/zkadmin/software/zookeeper-3.4.6/conf/log4j.properties',
    source  => 'puppet:///modules/zookeeper/3.4.6/conf/log4j.properties',
    mode    => '0644',
    owner   => 'zkadmin',
    group   => 'zookeeper',
    require => File['zookeeper_conf_dir'],
  }
  file { 'zoo_sample.cfg':
    path    => '/home/zkadmin/software/zookeeper-3.4.6/conf/zoo.cfg',
    source  => 'puppet:///modules/zookeeper/3.4.6/conf/zoo.cfg',
    mode    => '0644',
    owner   => 'zkadmin',
    group   => 'zookeeper',
    require => File['zookeeper_conf_dir'],
  }
  
  # DATA LOCATIONS:
  file { 'data01_zookeeper':
    path    => '/data01/zookeeper',
    ensure  => directory,
    mode    => '0755',
    owner   => 'zkadmin',
    group   => 'zookeeper',
    require => [ File['data01'], User['zkadmin'] ],
  }
  file { 'zookeeper_data':
    path    => '/data01/zookeeper/data',
    ensure  => directory,
    mode    => '0755',
    owner   => 'zkadmin',
    group   => 'zookeeper',
    require => [ File['data01_zookeeper'], User['zkadmin'] ],
  }
  file { 'zookeeper_log':
    path    => '/data01/zookeeper/logs',
    ensure  => directory,
    mode    => '0755',
    owner   => 'zkadmin',
    group   => 'zookeeper',
    require => [ File['data01_zookeeper'], User['zkadmin'] ],
  }
  file { 'zooserver_myid':
    path    => '/data01/zookeeper/data/myid',
    content => "${serverId}\n",
    require => File['zookeeper_data'],
  }
}