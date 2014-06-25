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
  include every_node
}
node 'master01.bigdata' {
  include hadoop_master
  include hadoop_old_demo
  include hadoop::master::mount_data01_hadoop_nn_mirror
}
node 'worker01.bigdata' {
  include hadoop_slave
  include hadoop::master::share_data01_hadoop_nn_mirror
  #class { 'elasticsearch':
  #  hostname => 'worker01.bigdata',
  #}
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
