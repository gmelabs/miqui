class hadoop_old_demo {
  
  # Web dashboard user
  # password generated using $ openssl passwd -1
  user { 'demo':
    ensure     => present,
    gid        => 'hadoop',
    managehome => true,
    home       => '/home/demo',
    shell      => '/bin/bash',
    password   => '$1$3wJtnI1K$bvOAWh/SU/BUitYhtMxgX0',
    require    => Group['hadoop'],
  }
  file { 'demo_home':
    path   => '/home/demo',
    ensure => directory,
    mode   => '0750',
    require => User['demo'],
  }
  file { '/home/demo/runtime':
    ensure => link,
    target => '/home/hdadmin/runtime',
    require => File['hdruntime'],
  }
  file { 'demo_jobs_dir':
    path    => '/home/demo/jobs',
    ensure  => directory,
    mode    => '0755',
    require => File['demo_home'],
  }
  file { 'usecases_dir':
    path    => '/home/demo/jobs/usecases',
    ensure  => directory,
    mode    => '0755',
    require => File['demo_jobs_dir'],
  }
  file { '/home/demo/jobs/usecases/lib':
    ensure => link,
    target => '/home/hdadmin/work/lib',
    require => File[
#      'hdworklib',
      'usecases_dir'
    ],
  }
  file { 'demo_bashrc':
    path    => '/home/demo/.bashrc',
    source  => 'puppet:///modules/hadoop_old_demo/home/demo/.bashrc',
    mode    => '0644',
    owner   => 'demo',
    group   => 'hadoop',
    require => File['demo_home'],
  }
}