class admin_node {
  file { 'dhcpd.conf':
    path   => '/etc/dhcp/dhcpd.conf',
    source => 'puppet:///modules/admin_node/etc/dhcp/dhcpd.conf',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
  file { 'sshd.conf':
    path   => '/etc/ssh/sshd_config',
    source => 'puppet:///modules/admin_node/etc/ssh/sshd_config',
    mode   => '0600',
    owner  => 'root',
    group  => 'root',
  }
  file { 'eth0.conf':
    path   => '/etc/sysconfig/network-scripts/ifcfg-eth0',
    source => 'puppet:///modules/admin_node/etc/sysconfig/network-scripts/ifcfg-eth0',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
  file { 'iptables.conf':
    path   => '/etc/sysconfig/iptables',
    source => 'puppet:///modules/admin_node/etc/sysconfig/iptables',
    mode   => '0600',
    owner  => 'root',
    group  => 'root',
  }
  service { 'iptables':
    ensure     => running,
    hasrestart => true,
    enable     => true,
    subscribe  => File['iptables.conf'],
  }
  file { 'network.conf':
    path   => '/etc/sysconfig/network',
    source => 'puppet:///modules/admin_node/etc/sysconfig/network',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
  service { 'network':
    ensure     => running,
    enable     => true,
    subscribe  => File['network.conf', 'eth0.conf'],
  }
  file { 'anaconda-ks.conf':
    path   => '/var/lib/tftpboot/images/centos/6/x86_64/anaconda-ks-nodes-vm.cfg',
    source => 'puppet:///modules/admin_node/var/lib/tftpboot/images/centos/6/x86_64/anaconda-ks-nodes-vm.cfg',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
  file { 'pxelinux-default.conf':
    path   => '/var/lib/tftpboot/pxelinux.cfg/default',
    source => 'puppet:///modules/admin_node/var/lib/tftpboot/pxelinux.cfg/default',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
}