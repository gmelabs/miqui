class worker_node {
  
  include every_node
  
  # DATA LOCATIONS:
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
}