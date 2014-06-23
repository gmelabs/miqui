node 'vmmadbd00' {
  #class { 'every_node':
  #  hostname => 'admin.bigdata',
  #}
  #include admin_node
  #include gitorious
  #include tomcat
  #include ganglia::gmetad  #<-- TODO
  #include ganglia::gweb    #<-- TODO
}
node 'newnode' {
  class { 'every_node':
    hostname => 'newnode.bigdata',
  }
}
node 'master01.bigdata' {
  class { 'hadoop_master':
    hostname => 'master01.bigdata',
  }
  include hadoop_old_demo
}
node 'worker01.bigdata' {
  class { 'hadoop_slave':
    hostname => 'worker01.bigdata',
  }
  #include elasticsearch
}
node 'worker02.bigdata' {
  class { 'hadoop_slave':
    hostname => 'worker02.bigdata',
  }
}
node 'lab01.bigdata'{
  class { 'worker_node':
    hostname => 'lab01.bigdata',
  }
  include virtualbox
  #include nfs::server
}
node 'lab02.bigdata' {
  class { 'worker_node':
    hostname => 'lab02.bigdata',
  }
  include virtualbox
  #include nfs::client
}
Package {  allow_virtual => true, }