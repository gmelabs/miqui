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
    minute => "*/5",
    user => "root",
  }
  package { 'tftp':
    ensure => installed,
  }
}
