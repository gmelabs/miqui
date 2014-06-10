class virtualbox {
  
  yumrepo{ 'virtualbox':
    baseurl  => 'http://download.virtualbox.org/virtualbox/rpm/el/$releasever/$basearch',
    descr    => 'VirtualBox repository',
    enabled  => 1,
    gpgcheck => 1,
    gpgkey => 'http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc',
  }

  package { 'VirtualBox-4.3': 
    ensure  => installed, 
    require => [
    Yumrepo['virtualbox', 'epel'],
    Package['kernel-devel', 'gcc'],
    ]
  }
  
  #$requiredVBpackages = ['kernel-devel', 'gcc']
  package { ['kernel-devel', 'gcc']:
    ensure => installed,
  }

  file{ 'link-kernels':
    ensure  => link,
    path    => '/lib/modules/2.6.32-431.el6.x86_64/build',
    target  => '/usr/src/kernels/2.6.32-431.17.1.el6.x86_64',
    require => Package['kernel-devel', 'gcc'],     
  }
}