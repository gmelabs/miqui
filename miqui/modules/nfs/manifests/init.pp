class nfs{
  $nfsUtils = ['nfs-utils', 'nfs-utils-lib']
  
  package { $nfsUtils:
    ensure => installed,
  }
  
  service { 'nfs':
    ensure  => running,
    require => Package[$nfsUtils],
  }
  
  service { 'rpcbind':
    ensure  => running,
    require => Package[$nfsUtils],
  }
  
  service{ 'iptables':
    ensure => stopped,
  }
}

class nfs::server inherits nfs{
  
  file{'exports':
    path   => '/etc/exports',
    source => 'puppet:///modules/nfs/etc/exports',
    mode   => '644',
    owner  => 'root',
    group  => 'root',
  }
  
  file{'dfs_name_2':
      path   => '/data01/hadoop/dfs/name_2',
      ensure => directory,
      mode   => '755',
      owner  => 'root',
      group  => 'root',
  }
  
  exec{'exportfs':
    command   => 'exportfs -a',
    subscribe => File['exports'],
  }
}

class nfs::client inherits nfs{
  
    mount{'dfs_name':
    name    => '/data01/hadoop/dfs/name',
    device  => 'worker01.bigdata:/data01/hadoop/dfs/name_2',
    fstype  => 'nfs4',
    ensure  => 'mounted',
    options => 'defaults',
    atboot  => true,
  }
}