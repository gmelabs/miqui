class virtualbox{
  class { packages: require => Stage['main'] }
  class { link_kernel: before => Stage['main'] }
}

class packages {
  
  $requiredVBpackages = ['kernel-devel', 'gcc']
  
  yumrepo{ 'virtualbox':
    baseurl  => 'http://download.virtualbox.org/virtualbox/rpm/el/$releasever/$basearch',
    descr    => 'VirtualBox repository',
    enabled  => 1,
    gpgcheck => 1,
    gpgkey => 'http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc',
    require => Package[$requiredVBpackages],
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
  
}

class link_kernel {
    file{ 'link-kernels':
    ensure  => link,
    path    => '/lib/modules/2.6.32-431.el6.x86_64/build',
    target  => '/usr/src/kernels/2.6.32-431.17.1.el6.x86_64',
  }   
  
}  