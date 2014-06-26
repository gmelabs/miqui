node 'vmmadbd00' {
  #class { 'every_node':
  #  hostname => 'admin.bigdata',
  #}
  #include admin_node
  #include gitorious
  #include tomcat
  #include ganglia::gmetad  #<-- TODO (as part of admin_node)
  #include ganglia::gweb    #<-- TODO (as part of admin_node)
}
node 'newnode' {
  include every_node
}
node 'master01.bigdata' {
  include hadoop_master
  include hadoop_old_demo
  include hadoop::master::nn
}
node 'worker01.bigdata' {
  include hadoop_slave
  include hadoop::master::nn_mirror
  #include elasticsearch
}
node 'worker02.bigdata' {
  include hadoop_slave
}
node 'lab01.bigdata' {
  include worker_node
  include virtualbox
}
node 'lab02.bigdata' {
  include worker_node
  include virtualbox
}

Package {  allow_virtual => true, }
