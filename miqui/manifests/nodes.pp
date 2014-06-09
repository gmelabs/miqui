node 'newnode' {
  include every_node
}
node 'master01.bigdata' {
  include every_node
  include hadoop
  include virtualbox
}
node 'worker01.bigdata' {
  include every_node
  include hadoop
  include elasticsearch
}
node 'worker02.bigdata' {
  include every_node
  include hadoop
}