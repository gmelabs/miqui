class master_node ($hostname) {
  
  class { 'every_node':
    hostname => $hostname,
  }
  
  # DATA LOCATIONS:
  file { '/data01':
    ensure  => link,
    target  => '/',
  }
}