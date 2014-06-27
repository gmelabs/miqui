class every_node {
  
  file { 'hosts':
    path   => '/etc/hosts',
    source => 'puppet:///modules/every_node/etc/hosts',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
  file { '.ssh':
    path   => '/root/.ssh',
    ensure => 'directory',
    mode   => '0700',
    owner  => 'root',
    group  => 'root',
  }
  file { 'known_hosts':
    path   => '/root/.ssh/known_hosts',
    source => 'puppet:///modules/every_node/root/.ssh/known_hosts',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    require => File['.ssh'],
  }
  file { 'authorized_keys':
    path   => '/root/.ssh/authorized_keys',
    source => 'puppet:///modules/every_node/root/.ssh/authorized_keys',
    mode   => '0600',
    owner  => 'root',
    group  => 'root',
    require => File['.ssh'],
  }
  file { 'puppet-apply':
    path   => '/root/puppet-apply.sh',
    source => 'puppet:///modules/every_node/root/puppet-apply.sh',
    mode   => '0700',
  }
  cron { 'puppet_cron':
    command => 'sh /root/puppet-apply.sh',
    minute => '*/10',
    user => "root",
  }
  package { 'tftp':
    ensure => installed,
  }
  file { 'RPM-GPG-KEY-EPEL-6':
    path   => '/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6',
    source => 'puppet:///modules/every_node/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6',
    mode   => '0644',
  }
  yumrepo { 'epel':
    mirrorlist => 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=x86_64',
    enabled    => 1,
    gpgcheck   => 1,
    gpgkey     => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6',
    require    => File['RPM-GPG-KEY-EPEL-6'],
  }
  #package { 'ganglia-gmond':
  #  ensure  => installed,
  #  require => Yumrepo['epel'],
  #}
  ## Requires $hostname attribute
  #file { 'gmond.conf':
  #  path    => '/etc/gmond.conf',
  #  content => template('every_node/etc/gmond.conf.erb'),
  #  owner   => 'ganglia',
  #  group   => 'ganglia',
  #  mode    => '644',
  #  require => Package['ganglia-gmond'],
  #}
}
