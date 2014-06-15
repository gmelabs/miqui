class hadoop_master {
  
  include hadoop
  
  file { 'hadoop_folder':
    path    => '/hadoop',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => User['hdadmin'],
  }
  
  # In virtual appliance, master node is also slave and so link cannot be created. It's ok.
  file { '/data01':
    ensure  => link,
    target  => '/',
    require => User['hdadmin'],
  }
  
  file { 'hadoop_master_tmp':
    path    => '/data01/hadoop/tmp',
    ensure  => directory,
    mode    => '0775',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['/data01'],
  }
}