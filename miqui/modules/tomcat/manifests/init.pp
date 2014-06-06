class tomcat {
  
  package { 'tomcat6':
    ensure => installed,
  }
  
  service { 'tomcat6':
    ensure => running,
    enable => true,
  }
}