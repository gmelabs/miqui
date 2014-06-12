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
  file { '/data01':
    ensure  => link,
    target  => '/',
    require => User['hdadmin'],
  }
  exec { 'do-install-rsa-key':
    command => 'cp /root/.ssh/id_rsa* /home/hdadmin/.ssh/ && chown hdadmin:hadoop /home/hdadmin/.ssh/id_rsa*',
    creates => '/home/hdadmin/id_rsa',
    require => File['.ssh', 'hdadmin_ssh_dir'],
  }

}