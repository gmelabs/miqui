# Spark for Hadoop1
class spark1 {
  
  group { 'spark':
    ensure => present,
  }
  user { 'spkadmin':
    ensure     => present,
    gid        => 'spark',
    managehome => true,
    home       => '/home/spkadmin',
    shell      => '/bin/bash',
    require    => Group['spark'],
  }
  file { 'spkadmin_home':
    path    => '/home/spkadmin',
    ensure  => directory,
    mode    => '0750',
    owner   => 'spkadmin',
    group   => 'spark',
    require => User['spkadmin'],
  }
  file { 'spksoftware':
    path    => '/home/spkadmin/software',
    ensure  => directory,
    mode    => '0755',
    owner   => 'spkadmin',
    group   => 'spark',
    require => File['spkadmin_home'],
  }
  file { 'spkruntime':
    path    => '/home/spkadmin/runtime',
    ensure  => directory,
    mode    => '0755',
    owner   => 'spkadmin',
    group   => 'spark',
    require => File['spkadmin_home'],
  }
  file { 'spkbashrc':
    path    => '/home/spkadmin/.bashrc',
    source  => 'puppet:///modules/spark1/home/spkadmin/.bashrc',
    mode    => '0644',
    owner   => 'spkadmin',
    group   => 'spark',
    require => File['spkadmin_home'],
  }
  file { 'install-java-4spk':
    path   => '/root/install-java-4spk.sh',
    source => 'puppet:///modules/spark1/root/install-java-4spk.sh',
    mode   => '0700',
  }
  file { 'install-spark1':
    path   => '/root/install-spark1.sh',
    source => 'puppet:///modules/spark1/root/install-spark1.sh',
    mode   => '0700',
  }
  
  exec { 'do-install-java-4spk':
    command => '/root/install-java-4spk.sh > /root/java-4spk-install.log',
    creates => '/root/java-4spk-installed-by-puppet',
    require => [
      File['install-java-4spk', 'spksoftware', 'spkruntime'],
      User['spkadmin'],
      Package['tftp'],
    ],
  }
  exec { 'do-install-spark1':
    command => '/root/install-spark1.sh > /root/spark1-install.log',
    creates => '/root/spark1-installed-by-puppet',
    require => [
      File['install-spark1', 'spksoftware', 'spkruntime'],
      User['spkadmin'],
      Package['tftp'],
    ],
  }
  file { 'java-4spk-installed.flag':
    path => '/root/java-4spk-installed-by-puppet',
    require => Exec['do-install-java-4spk'],
  }
  file { 'spark1-installed.flag':
    path => '/root/spark1-installed-by-puppet',
    require => Exec['do-install-spark1'],
  }
  
  file { 'spark1_conf_dir':
    path    => '/home/spkadmin/software/spark-1.0.0-hadoop1/conf',
    ensure  => directory,
    mode    => '0755',
    owner   => 'spkadmin',
    group   => 'spark',
    require => File['spark1-installed.flag'],
  }
  
  # CONFIG FILES:
  file { 'spark1_fairscheduler.xml':
    path    => '/home/spkadmin/software/spark-1.0.0-hadoop1/conf/fairscheduler.xml',
    source  => 'puppet:///modules/spark1/1.0.0/conf/fairscheduler.xml',
    mode    => '0644',
    owner   => 'spkadmin',
    group   => 'spark',
    require => File['spark1_conf_dir'],
  }
  file { 'spark1_log4j.properties':
    path    => '/home/spkadmin/software/spark-1.0.0-hadoop1/conf/log4j.properties',
    source  => 'puppet:///modules/spark1/1.0.0/conf/log4j.properties',
    mode    => '0644',
    owner   => 'spkadmin',
    group   => 'spark',
    require => File['spark1_conf_dir'],
  }
  file { 'spark1_metrics.properties':
    path    => '/home/spkadmin/software/spark-1.0.0-hadoop1/conf/metrics.properties',
    source  => 'puppet:///modules/spark1/1.0.0/conf/metrics.properties',
    mode    => '0644',
    owner   => 'spkadmin',
    group   => 'spark',
    require => File['spark1_conf_dir'],
  }
  file { 'spark1_slaves':
    path    => '/home/spkadmin/software/spark-1.0.0-hadoop1/conf/slaves',
    source  => 'puppet:///modules/spark1/1.0.0/conf/slaves',
    mode    => '0644',
    owner   => 'spkadmin',
    group   => 'spark',
    require => File['spark1_conf_dir'],
  }
  file { 'spark1_spark-defaults.conf':
    path    => '/home/spkadmin/software/spark-1.0.0-hadoop1/conf/spark-defaults.conf',
    source  => 'puppet:///modules/spark1/1.0.0/conf/spark-defaults.conf',
    mode    => '0644',
    owner   => 'spkadmin',
    group   => 'spark',
    require => File['spark1_conf_dir'],
  }
  file { 'spark1_spark-env.sh':
    path    => '/home/spkadmin/software/spark-1.0.0-hadoop1/conf/spark-env.sh',
    source  => 'puppet:///modules/spark1/1.0.0/conf/spark-env.sh',
    mode    => '0644',
    owner   => 'spkadmin',
    group   => 'spark',
    require => File['spark1_conf_dir'],
  }
  
  # DATA LOCATIONS:
  # TODO: Ojo a los logs
}
