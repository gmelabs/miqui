class storm {
  
  package { 'python':
    ensure => installed,
  }
  
  group { 'storm':
    ensure => present,
  }
  user { 'stmadmin':
    ensure     => present,
    gid        => 'storm',
    managehome => true,
    home       => '/home/stmadmin',
    shell      => '/bin/bash',
    require    => Group['storm'],
  }
  file { 'stmadmin_home':
    path    => '/home/stmadmin',
    ensure  => directory,
    mode    => '0750',
    owner   => 'stmadmin',
    group   => 'storm',
    require => User['stmadmin'],
  }
  file { 'stmsoftware':
    path    => '/home/stmadmin/software',
    ensure  => directory,
    mode    => '0755',
    owner   => 'stmadmin',
    group   => 'storm',
    require => File['stmadmin_home'],
  }
  file { 'stmruntime':
    path    => '/home/stmadmin/runtime',
    ensure  => directory,
    mode    => '0755',
    owner   => 'stmadmin',
    group   => 'storm',
    require => File['stmadmin_home'],
  }
  file { 'stmbashrc':
    path    => '/home/stmadmin/.bashrc',
    source  => 'puppet:///modules/storm/home/stmadmin/.bashrc',
    mode    => '0644',
    owner   => 'stmadmin',
    group   => 'storm',
    require => File['stmadmin_home'],
  }
  file { 'install-java-4storm':
    path   => '/root/install-java-4storm.sh',
    source => 'puppet:///modules/storm/root/install-java-4storm.sh',
    mode   => '0700',
  }
  file { 'install-storm':
    path   => '/root/install-storm.sh',
    source => 'puppet:///modules/storm/root/install-storm.sh',
    mode   => '0700',
  }
  
  exec { 'do-install-java-4storm':
    command => '/root/install-java-4storm.sh > /root/java-4storm-install.log',
    creates => '/root/java-4storm-installed-by-puppet',
    require => [
      File['install-java-4storm', 'stmsoftware', 'stmruntime'],
      User['stmadmin'],
      Package['tftp'],
    ],
  }
  exec { 'do-install-storm':
    command => '/root/install-storm.sh > /root/storm-install.log',
    creates => '/root/storm-installed-by-puppet',
    require => [
      File['install-storm', 'stmsoftware', 'stmruntime'],
      User['stmadmin'],
      Package['tftp'],
    ],
  }
  file { 'java-4storm-installed.flag':
    path => '/root/java-4storm-installed-by-puppet',
    require => Exec['do-install-java-4storm'],
  }
  file { 'storm-installed.flag':
    path => '/root/storm-installed-by-puppet',
    require => Exec['do-install-storm'],
  }
  
  service { 'supervisord':
    ensure     => running,
    hasrestart => true,
    enable     => true,
    subscribe  => File['supervisord.conf'],
    require    => [
      File[
        'supervisord.conf',
        'java-4storm-installed.flag',
        'storm-installed.flag',
        'storm_log'
      ],
      Package['supervisor'],
    ],
  }
  
  file { 'storm_conf_dir':
    path    => '/home/stmadmin/software/storm-0.9.1-incubating/conf',
    ensure  => directory,
    mode    => '0755',
    owner   => 'stmadmin',
    group   => 'storm',
    require => File['storm-installed.flag'],
  }
  
  # CONFIG FILES:
  file { 'storm.yaml':
    path    => '/home/stmadmin/software/storm-0.9.1-incubating/conf/storm.yaml',
    source  => 'puppet:///modules/storm/0.9.1-incubating/conf/storm.yaml',
    mode    => '0644',
    owner   => 'stmadmin',
    group   => 'storm',
    require => File['storm_conf_dir'],
  }
  
  # DATA LOCATIONS:
  file { 'storm_data':
    path    => '/data01/storm/data',
    ensure  => directory,
    mode    => '0755',
    owner   => 'stmadmin',
    group   => 'storm',
    require => [ File['data01_storm'], User['stmadmin'] ],
  }
  # TODO: Ojo que esta escribiendo logs en $STORM_HOME/logs mucho mas voluminosos
  # Estudiar la posibilidad de forzar un symlink a 'storm_log'
  file { 'storm_log':
    path    => '/data01/storm/logs',
    ensure  => directory,
    mode    => '0755',
    owner   => 'stmadmin',
    group   => 'storm',
    require => [ File['data01_storm'], User['stmadmin'] ],
  }
}

class storm::nimbus inherits storm {
  include supervisord::storm_nimbus
  # DATA LOCATIONS:
  file { 'data01_storm':
    path    => '/data01/storm',
    ensure  => directory,
    mode    => '0755',
    owner   => 'stmadmin',
    group   => 'storm',
    require => [ File['/data01'], User['stmadmin'] ],
  }
}

class storm::supervisor inherits storm {
  include supervisord::storm_supervisor
  # DATA LOCATIONS:
  file { 'data01_storm':
    path    => '/data01/storm',
    ensure  => directory,
    mode    => '0755',
    owner   => 'stmadmin',
    group   => 'storm',
    require => [ File['data01'], User['stmadmin'] ],
  }
}
