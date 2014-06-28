# Requires $hostname attribute in format [host-name].[cluster-name]. Example: worker05.bigdata
class ganglia ($hostname) {
  
}
class ganglia::gmond {
  
  package { 'ganglia-gmond':
    ensure  => installed,
    require => Yumrepo['epel'],
  }
  file { 'gmond.conf':
    path    => '/etc/gmond.conf',
    content => template('every_node/etc/gmond.conf.erb'),
    owner   => 'ganglia',
    group   => 'ganglia',
    mode    => '644',
    require => Package['ganglia-gmond'],
  }
}
# TODO - Manually installed. Please document it
class ganglia::gmetad {
  
}
# TODO - Manually installed. Please document it
class ganglia::gweb {
  
}