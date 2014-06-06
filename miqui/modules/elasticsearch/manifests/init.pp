class elasticsearch {
  
  include every_node
  
  group { 'elastic':
    ensure => present,
  }

  user { 'esadmin':
    ensure     => present,
    gid        => 'elastic',
    managehome => true,
    home       => '/home/esadmin',
    shell      => '/bin/bash',
    require    => Group['elastic'],
  }
  file { 'esadmin_home':
    path    => '/home/esadmin',
    ensure  => directory,
    mode    => '0750',
    owner   => 'esadmin',
    group   => 'elastic',
    require => User['esadmin'],
  }
  file { 'essoftware':
     path   => '/home/esadmin/software',
     ensure => directory,
     mode   => '0755',
     owner  => 'esadmin',
     group  => 'elastic',
     require => File['esadmin_home'],
  }
  file { 'esruntime':
     path    => '/home/esadmin/runtime',
     ensure  => directory,
     mode    => '0755',
     owner   => 'esadmin',
     group   => 'elastic',
     require => File['esadmin_home'],
  }
  file { 'install-elasticsearch':
    path   => '/root/install-elasticsearch.sh',
    source => 'puppet:///modules/elasticsearch/root/install-elasticsearch.sh',
    mode   => '0700',
  }

  exec { 'do-install-elasticsearch':
    command => '/root/install-elasticsearch.sh > /root/elasticsearch-install.log',
    creates => '/root/elasticsearch-installed-by-puppet',
    require => [
      File['install-elasticsearch', 'essoftware'],
      User['esadmin'],
      Package['tftp'],
    ],
  }
  file { 'elasticsearch-installed.flag':
    path => '/root/elasticsearch-installed-by-puppet',
  }

  file { 'elasticsearch_conf_dir':
    path    => '/home/esadmin/software/elasticsearch-1.2.1/config',
    ensure  => directory,
    mode    => '0755',
    owner   => 'esadmin',
    group   => 'elastic',
    require => File['elasticsearch-installed.flag'],
  }
  # Provisionally, all nodes are the same. Somewhen there'll be ES-roles
  file { 'elasticsearch.conf':
    path    => '/home/esadmin/software/elasticsearch-1.2.1/config/elasticsearch.yml',
    source  => 'puppet:///modules/elasticsearch/1.2.1/config/elasticsearch.yml',
    mode    => '0644',
    owner   => 'esadmin',
    group   => 'elastic',
    require => File['elasticsearch_conf_dir'],
  }
  file { 'logging.conf':
    path    => '/home/esadmin/software/elasticsearch-1.2.1/config/logging.yml',
    source  => 'puppet:///modules/elasticsearch/1.2.1/config/logging.yml',
    mode    => '0644',
    owner   => 'esadmin',
    group   => 'elastic',
    require => File['elasticsearch_conf_dir'],
  }
}