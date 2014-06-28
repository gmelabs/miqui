# Downloaded from
# wget http://download.splunk.com/products/splunk/releases/6.1.1/universalforwarder/linux/splunkforwarder-6.1.1-207789-Linux-x86_64.tgz
# we repackaged it as software/splunkforwarder-6.1.1.tgz on the tftp server
class splunkforwarder {
  
  group { 'splunk':
    ensure => present,
  }
  user { 'spladmin':
    ensure     => present,
    gid        => 'splunk',
    managehome => true,
    home       => '/home/spladmin',
    shell      => '/bin/bash',
    require    => Group['splunk'],
  }
  file { 'spladmin_home':
    path    => '/home/spladmin',
    ensure  => directory,
    mode    => '0750',
    owner   => 'spladmin',
    group   => 'splunk',
    require => User['spladmin'],
  }
  file { 'splsoftware':
    path    => '/home/spladmin/software',
    ensure  => directory,
    mode    => '0755',
    owner   => 'spladmin',
    group   => 'splunk',
    require => File['spladmin_home'],
  }
  file { 'splruntime':
    path    => '/home/spladmin/runtime',
    ensure  => directory,
    mode    => '0755',
    owner   => 'spladmin',
    group   => 'splunk',
    require => File['spladmin_home'],
  }
  file { 'splbashrc':
    path    => '/home/spladmin/.bashrc',
    source  => 'puppet:///modules/splunkforwarder/home/spladmin/.bashrc',
    mode    => '0644',
    owner   => 'spladmin',
    group   => 'splunk',
    require => File['spladmin_home'],
  }
  file { 'install-splunkforwarder':
    path   => '/root/install-splunkforwarder.sh',
    source => 'puppet:///modules/splunkforwarder/root/install-splunkforwarder.sh',
    mode   => '0700',
  }
  
  exec { 'do-install-splunkforwarder':
    command => '/root/install-splunkforwarder.sh > /root/splunkforwarder-install.log',
    creates => '/root/splunkforwarder-installed-by-puppet',
    require => [
      File['install-splunkforwarder', 'splsoftware', 'splruntime'],
      User['spladmin'],
      Package['tftp'],
    ],
  }
  file { 'splunkforwarder-installed.flag':
    path => '/root/splunkforwarder-installed-by-puppet',
    require => Exec['do-install-splunkforwarder'],
  }
  
  # CONFIG FILES:
  file { 'inputs.conf':
    path   => '/home/spladmin/software/splunkforwarder-6.1.1/etc/apps/search/local/inputs.conf',
    source => 'puppet:///modules/splunkforwarder/6.1.1/etc/apps/search/local/inputs.conf',
    mode   => '0644',
    owner   => 'spladmin',
    group   => 'splunk',
    require => File['splunkforwarder-installed.flag'],
  }
  file { 'outputs.conf':
    path   => '/home/spladmin/software/splunkforwarder-6.1.1/etc/system/local/outputs.conf',
    source => 'puppet:///modules/splunkforwarder/6.1.1/etc/system/local/outputs.conf',
    mode   => '0644',
    owner   => 'spladmin',
    group   => 'splunk',
    require => File['splunkforwarder-installed.flag'],
  }
  
  # DONDE VAN LOS LOGS DE SPLUNK Y DEL FORWARDER?
  # DONDE LOS DATOS? (INDICES,...)
}
