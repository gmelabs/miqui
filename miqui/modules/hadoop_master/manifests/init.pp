class hadoop_master {
  
  include master_node
  include hadoop
  
  # DATA LOCATIONS:
  file { 'hadoop_folder':
    path    => '/hadoop',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
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