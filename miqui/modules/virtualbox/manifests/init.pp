class virtualbox {
  
  $requiredVBpackages = ['kernel-devel', 'gcc']
  
  package { $requiredVBpackages:
    ensure => installed,
  }
  
  yumrepo { 'virtualbox':
    baseurl  => 'http://download.virtualbox.org/virtualbox/rpm/el/$releasever/$basearch',
    descr    => 'VirtualBox repository',
    enabled  => 1,
    gpgcheck => 1,
    gpgkey   => 'http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc',
  }
  
  package { 'VirtualBox-4.3':
    ensure  => installed,
    require => [
      Yumrepo['virtualbox'],
      Package[$requiredVBpackages],
    ],
  }
}