class virtualbox {
  
  $requiredVBpackages = ['kernel-devel', 'gcc']
  
  yumrepo{ 'virtualbox':
    baseurl  => 'http://download.virtualbox.org/virtualbox/rpm/el/$releasever/$basearch',
    descr    => 'VirtualBox repository',
    enabled  => 1,
    gpgcheck => 1,
    gpgkey => 'http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc',
    require => [
    Package[$requiredVBpackages],
    ],
  }

  package { 'VirtualBox-4.3': 
    ensure  => installed, 
    require => [
    Yumrepo['virtualbox'],
    Package[$requiredVBpackages],
    ]
  }  
  
  package { $requiredVBpackages:
    ensure => installed,
  }

  file{ 'link-kernels':
    ensure  => link,
    path    => '/lib/modules/2.6.32-431.el6.x86_64/build',
    target  => '/usr/src/kernels/2.6.32-431.17.1.el6.x86_64',
    stage   => post, 
  }
  
  stage{'post':
    require => Stage['main'],
  }
}