node 'newnode' {
  include every_node
}
node 'master01.bigdata' {
  include every_node
  include hadoop
}
node 'worker01.bigdata' {
  include every_node
  include hadoop
}
node 'worker02.bigdata' {
  include every_node
  include hadoop
}