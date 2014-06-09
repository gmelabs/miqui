class virtualbox {
  
  yumrepo{ 'virtualbox':
    baseurl  => 'http://download.virtualbox.org/virtualbox/rpm/el/$releasever/$basearch',
    descr    => 'VirtualBox repository',
    enabled  => 1,
    gpgcheck => 0,
  }
  
  package { 'VirtualBox-4.3': 
    ensure  => installed, 
    require => Yumrepo['virtualbox'],
  }
}