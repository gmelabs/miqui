# Shark for Hadoop1
class shark1 {
  
  group { 'shark':
    ensure => present,
  }
  user { 'shkadmin':
    ensure     => present,
    gid        => 'shark',
    groups     => ['spark', 'hadoop'],
    managehome => true,
    home       => '/home/shkadmin',
    shell      => '/bin/bash',
    require    => Group['shark'],
  }
  file { 'shkadmin_home':
    path    => '/home/shkadmin',
    ensure  => directory,
    mode    => '0750',
    owner   => 'shkadmin',
    group   => 'shark',
    require => User['shkadmin'],
  }
  file { 'shksoftware':
    path    => '/home/shkadmin/software',
    ensure  => directory,
    mode    => '0755',
    owner   => 'shkadmin',
    group   => 'shark',
    require => File['shkadmin_home'],
  }
  file { 'shkruntime':
    path    => '/home/shkadmin/runtime',
    ensure  => directory,
    mode    => '0755',
    owner   => 'shkadmin',
    group   => 'shark',
    require => File['shkadmin_home'],
  }
  file { 'shkbashrc':
    path    => '/home/shkadmin/.bashrc',
    source  => 'puppet:///modules/shark1/home/shkadmin/.bashrc',
    mode    => '0644',
    owner   => 'shkadmin',
    group   => 'shark',
    require => File['shkadmin_home'],
  }
  file { 'install-java-4shk':
    path   => '/root/install-java-4shk.sh',
    source => 'puppet:///modules/shark1/root/install-java-4shk.sh',
    mode   => '0700',
  }
  file { 'install-shark1':
    path   => '/root/install-shark1.sh',
    source => 'puppet:///modules/shark1/root/install-shark1.sh',
    mode   => '0700',
  }
  
  exec { 'do-install-java-4shk':
    command => '/root/install-java-4shk.sh > /root/java-4shk-install.log',
    creates => '/root/java-4shk-installed-by-puppet',
    require => [
      File['install-java-4shk', 'shksoftware', 'shkruntime'],
      User['shkadmin'],
      Package['tftp'],
    ],
  }
  exec { 'do-install-shark1':
    command => '/root/install-shark1.sh > /root/shark1-install.log',
    creates => '/root/shark1-installed-by-puppet',
    require => [
      File['install-shark1', 'shksoftware', 'shkruntime'],
      User['shkadmin'],
      Package['tftp'],
    ],
  }
  file { 'java-4shk-installed.flag':
    path => '/root/java-4shk-installed-by-puppet',
    require => Exec['do-install-java-4shk'],
  }
  file { 'shark1-installed.flag':
    path => '/root/shark1-installed-by-puppet',
    require => Exec['do-install-shark1'],
  }
  
  file { 'shark1_conf_dir':
    path    => '/home/shkadmin/software/shark-0.9.1-hadoop1/conf',
    ensure  => directory,
    mode    => '0755',
    owner   => 'shkadmin',
    group   => 'shark',
    require => File['shark1-installed.flag'],
  }
  
  # CONFIG FILES:
  file { 'shark1_log4j.properties':
    path    => '/home/shkadmin/software/shark-0.9.1-hadoop1/conf/log4j.properties',
    source  => 'puppet:///modules/shark1/0.9.1/conf/log4j.properties',
    mode    => '0644',
    owner   => 'shkadmin',
    group   => 'shark',
    require => File['shark1_conf_dir'],
  }
  file { 'shark1_shark-env.sh':
    path    => '/home/shkadmin/software/shark-0.9.1-hadoop1/conf/shark-env.sh',
    source  => 'puppet:///modules/shark1/0.9.1/conf/shark-env.sh',
    mode    => '0644',
    owner   => 'shkadmin',
    group   => 'shark',
    require => File['shark1_conf_dir'],
  }
  
  # DATA LOCATIONS:
  # TODO: Ojo a los logs
  # Ojo! Esta es la configuracion para estar en un nodo master
  file { 'data01_shark1':
    path    => '/data01/shark1',
    ensure  => directory,
    mode    => '0755',
    owner   => 'shkadmin',
    group   => 'shark',
    require => [ File['/data01'], User['shkadmin'] ],
  }
  file { 'shark1_data':
    path    => '/data01/shark1/data',
    ensure  => directory,
    mode    => '0755',
    owner   => 'shkadmin',
    group   => 'shark',
    require => File['data01_shark1'],
  }
}
