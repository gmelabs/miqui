node 'newnode' {
  include every_node
}
# Compatibles? Uno tiene /data01 y otro crea un link
node 'master01.bigdata' {
  include hadoop_master
  include hadoop_slave
}
node 'worker01.bigdata' {
  include hadoop_slave
  include elasticsearch
}
node 'worker02.bigdata' {
  include hadoop_slave
}
node 'lab01.bigdata'{
  include hadoop_slave
  include virtualbox
}
node 'lab02.bigdata' {
  include every_node
  include virtualbox
}