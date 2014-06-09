class virtualbox {
  
  yumrepo{ 'virtualbox':
    baseurl  => 'http://download.virtualbox.org/virtualbox/rpm/rhel/',
    descr    => 'VirtualBox repository',
    enabled  => 1,
    gpgcheck => 0,
  }
  
  package { 'virtualbox-4.3': 
    ensure => installed, 
  }
}