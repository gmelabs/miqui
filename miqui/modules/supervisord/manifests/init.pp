class supervisord {
  
  package { 'supervisor':
    ensure  => installed,
    require => Yumrepo['epel'],
  }
}

class supervisord::supervisord_zookeeper inherits supervisord {
  file { 'supervisord.conf':
    path   => '/etc/supervisord.conf',
    source => 'puppet:///modules/supervisord/etc/supervisord_zookeeper.conf',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
}

class supervisord::storm_nimbus inherits supervisord {
  file { 'supervisord.conf':
    path   => '/etc/supervisord.conf',
    source => 'puppet:///modules/supervisord/etc/supervisord_storm_master.conf',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
}

class supervisord::storm_supervisor inherits supervisord {
  file { 'supervisord.conf':
    path   => '/etc/supervisord.conf',
    source => 'puppet:///modules/supervisord/etc/supervisord_storm_slave.conf',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
}
