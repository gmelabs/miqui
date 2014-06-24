class hadoop_slave {
  
  include worker_node
  include hadoop
  
  # DATA LOCATIONS:
  file { 'data01_hadoop':
    path    => '/data01/hadoop',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => [ File['data01'], User['hdadmin'] ],
  }
  file { 'data02_hadoop':
    path    => '/data02/hadoop',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => [ File['data02'], User['hdadmin'] ],
  }
  file { 'data03_hadoop':
    path    => '/data03/hadoop',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => [ File['data03'], User['hdadmin'] ],
  }
  file { 'data04_hadoop':
    path    => '/data04/hadoop',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => [ File['data04'], User['hdadmin'] ],
  }
  file { 'data05_hadoop':
    path    => '/data05/hadoop',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => [ File['data05'], User['hdadmin'] ],
  }
  file { 'data06_hadoop':
    path    => '/data06/hadoop',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => [ File['data06'], User['hdadmin'] ],
  }
}