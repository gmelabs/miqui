node 'vmmadbd00' {
  #include every_node
  #include admin_node
  #include gitorious
  #include tomcat
  #include ganglia::gmetad
  #include ganglia::gweb
}
node 'newnode' {
  include every_node
}
node 'master01.bigdata' {
  include hadoop::master::nn
  include hadoop_old_demo
  # Warn: Storm and Zookeeper are not compatible as both use supervidord.conf
  # Warn: This node listens on 8080 for storm UI
  include storm::nimbus
}
node 'worker01.bigdata' {
  include hadoop::slave
  include hadoop::nn_mirror # Este fallara porque el mirror definido debe ir en un master
  #include elasticsearch
  # Warn: Storm and Zookeeper are not compatible as both use supervidord.conf
  include storm::supervisor
  include spark1
}
node 'worker02.bigdata' {
  include hadoop::slave
  # Warn: Storm and Zookeeper are not compatible as both use supervidord.conf
  include storm::supervisor
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
