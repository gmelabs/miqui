class every_node {
  
  file { 'hosts':
    path   => '/etc/hosts',
    source => 'puppet:///modules/every_node/etc/hosts',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
  
  file { 'puppet-apply':
    path   => '/root/puppet-apply',
    source => 'puppet:///modules/every_node/root/puppet-apply.sh',
    mode   => '0700',
  }
  cron { 'puppet_cron':
    command => 'sh /root/puppet-apply.sh',
    minute => "*/5",
    user => "root",
  }
}
