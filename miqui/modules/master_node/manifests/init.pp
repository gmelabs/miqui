class master_node {
  
  include every_node
  
  # DATA LOCATIONS:
  file { '/data01':
    ensure  => link,
    target  => '/',
  }
}