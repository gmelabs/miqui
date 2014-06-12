class hadoop_slave {
  
  include hadoop
  
  file { 'data01':
    path    => '/data01',
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }
  file { 'data02':
    path    => '/data02',
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }
  file { 'data03':
    path    => '/data03',
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }
  file { 'data04':
    path    => '/data04',
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }
  file { 'data05':
    path    => '/data05',
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }
  file { 'data06':
    path    => '/data06',
    ensure  => directory,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }
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