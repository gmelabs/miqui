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
  
 #En VMs el master también es esclavo y el link no puede crearse  
  file { '/data01':
    ensure  => link,
    target  => '/',
    require => User['hdadmin'],
  }
  exec { 'do-install-rsa-key':
    command => '/bin/cp /root/.ssh/id_rsa* /home/hdadmin/.ssh/. && /bin/chown hdadmin:hadoop /home/hdadmin/.ssh/id_rsa*',
    creates => '/home/hdadmin/.ssh/id_rsa',
    require => File['.ssh', 'hdadmin_ssh_dir'],
  }

}