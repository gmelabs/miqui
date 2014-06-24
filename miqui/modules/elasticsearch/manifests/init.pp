class elasticsearch {
  
  include 'worker_node'
  
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
    path    => '/home/esadmin/software',
    ensure  => directory,
    mode    => '0755',
    owner   => 'esadmin',
    group   => 'elastic',
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
  file { 'esbashrc':
    path    => '/home/esadmin/.bashrc',
    source  => 'puppet:///modules/elasticsearch/home/esadmin/.bashrc',
    mode    => '0644',
    owner   => 'esadmin',
    group   => 'elastic',
    require => File['esadmin_home'],
  }
  file { 'install-java-4es':
    path   => '/root/install-java-4es.sh',
    source => 'puppet:///modules/elasticsearch/root/install-java-4es.sh',
    mode   => '0700',
  }
  file { 'install-elasticsearch':
    path   => '/root/install-elasticsearch.sh',
    source => 'puppet:///modules/elasticsearch/root/install-elasticsearch.sh',
    mode   => '0700',
  }
  
  exec { 'do-install-java-4es':
    command => '/root/install-java-4es.sh > /root/java-4es-install.log',
    creates => '/root/java-4es-installed-by-puppet',
    require => [
      File['install-java-4es', 'essoftware', 'esruntime'],
      User['esadmin'],
      Package['tftp'],
    ],
  }
  exec { 'do-install-elasticsearch':
    command => '/root/install-elasticsearch.sh > /root/elasticsearch-install.log',
    creates => '/root/elasticsearch-installed-by-puppet',
    require => [
      File['install-elasticsearch', 'essoftware', 'esruntime'],
      User['esadmin'],
      Package['tftp'],
    ],
  }
  file { 'java-4es-installed.flag':
    path => '/root/java-4es-installed-by-puppet',
    require => Exec['do-install-java-4es'],
  }
  file { 'elasticsearch-installed.flag':
    path => '/root/elasticsearch-installed-by-puppet',
    require => Exec['do-install-elasticsearch'],
  }
  
  file { 'elasticsearch_conf_dir':
    path    => '/home/esadmin/software/elasticsearch-1.2.1/config',
    ensure  => directory,
    mode    => '0755',
    owner   => 'esadmin',
    group   => 'elastic',
    require => File['elasticsearch-installed.flag'],
  }
  
  # CONFIG FILES:
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
  
  # DATA LOCATIONS:
  file { 'data02_es':
    path    => '/data02/elasticsearch',
    ensure  => directory,
    mode    => '0755',
    owner   => 'esadmin',
    group   => 'elastic',
    require => [ File['data02'], User['esadmin'] ],
  }
  file { 'data03_es':
    path    => '/data03/elasticsearch',
    ensure  => directory,
    mode    => '0755',
    owner   => 'esadmin',
    group   => 'elastic',
    require => [ File['data03'], User['esadmin'] ],
  }
  file { 'data04_es':
    path    => '/data04/elasticsearch',
    ensure  => directory,
    mode    => '0755',
    owner   => 'esadmin',
    group   => 'elastic',
    require => [ File['data04'], User['esadmin'] ],
  }
  file { 'data05_es':
    path    => '/data05/elasticsearch',
    ensure  => directory,
    mode    => '0755',
    owner   => 'esadmin',
    group   => 'elastic',
    require => [ File['data05'], User['esadmin'] ],
  }
  file { 'data06_es':
    path    => '/data06/elasticsearch',
    ensure  => directory,
    mode    => '0755',
    owner   => 'esadmin',
    group   => 'elastic',
    require => [ File['data06'], User['esadmin'] ],
  }
  file { 'es_data_1':
    path    => '/data02/elasticsearch/data',
    ensure  => directory,
    mode    => '0755',
    owner   => 'esadmin',
    group   => 'elastic',
    require => [ File['data02_es'], User['esadmin'] ],
  }
  file { 'es_data_2':
    path    => '/data03/elasticsearch/data',
    ensure  => directory,
    mode    => '0755',
    owner   => 'esadmin',
    group   => 'elastic',
    require => [ File['data03_es'], User['esadmin'] ],
  }
  file { 'es_data_3':
    path    => '/data04/elasticsearch/data',
    ensure  => directory,
    mode    => '0755',
    owner   => 'esadmin',
    group   => 'elastic',
    require => [ File['data04_es'], User['esadmin'] ],
  }
  file { 'es_tmp':
    path    => '/data05/elasticsearch/tmp',
    ensure  => directory,
    mode    => '0755',
    owner   => 'esadmin',
    group   => 'elastic',
    require => [ File['data05_es'], User['esadmin'] ],
  }
  file { 'es_log':
    path    => '/data06/elasticsearch/logs',
    ensure  => directory,
    mode    => '0755',
    owner   => 'esadmin',
    group   => 'elastic',
    require => [ File['data06_es'], User['esadmin'] ],
  }
}