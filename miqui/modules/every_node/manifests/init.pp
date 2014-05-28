class every_node {
  file { 'hosts':
    path   => '/etc/hosts',
    source => 'puppet:///modules/every_node/etc/hosts',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
}
