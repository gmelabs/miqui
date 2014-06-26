# Requires iptables to be open for nfs ports, or down.-
class nfs {
  
  $nfsUtils = ['nfs-utils', 'nfs-utils-lib']
  
  package { $nfsUtils:
    ensure => installed,
  }
  service { 'rpcbind':
    ensure  => running,
    enable  => true,
    require => Package[$nfsUtils],
  }
  service { 'nfs':
    ensure  => running,
    enable  => true,
    require => Service['rpcbind'],
  }
}

# To share a directory you must implement a subclass of nfs::share like in the example below
# and set the right values for its variables:
# 
#class mymodule::share_my_directory inherits nfs::share {
#  $execResourceId     = 'do-share-my_directory' # ID for this puppet resource
#  $requiredResourceId = 'requiredResourceId'    # ID of File resource that should exist
#  $sharedPath = 'my_directory'                               # Complete path of the shared directory
#  $sharedTo   = 'host or network for sharing directory to'   # Example: 192.168.100.0/24
#  $mode       = 'rw'                                         # 'rw' for read/write, or 'ro' for read only
#  $syncmode   = 'sync'                                       # 'sync' for synchronous write, 'async' for asynchronous
#  # ---------------------------------------------------------
#  # do not modify beyond this line
#  # ---------------------------------------------------------
#  exec { "$execResourceId":
#    onlyif  => "/bin/egrep -c -v '^${sharedPath}[ ]' /etc/exports",
#    command => "/bin/echo '${sharedPath} ${sharedTo}(${mode},${syncmode})' >> /etc/exports",
#    require => [
#      Exec['do-reset-exports-list'],
#      File[$requiredResourceId]
#    ],
#  }
#  Exec["$execResourceId"] -> Exec['exportfs']
#}
class nfs::share inherits nfs {
  exec { 'do-reset-exports-list':
    command => '/bin/echo -e "# HEADER: This file is managed by puppet.\n# HEADER: It cannot be managed manually, and it is definitely not recommended." > /etc/exports',
  }
  # Execute before sharing a directory with:
  # Exec['my_share_command'] -> Exec['exportfs']
  exec { 'exportfs':
    command   => '/usr/sbin/exportfs -a',
  }
}

# To mount an existing external shared folder you must implement a subclass of nfs like in the example below
# and set the right values for its variables:
# 
#class mymodule::mount_my_directory inherits nfs::mount {
#  $mountResourceId = 'mount-my_directory'    # ID for this puppet resource
#  $requiredResourceId = 'requiredResourceId' # ID of File resource that should exist
#  $mountPath    = 'my_directory'                                     # Local directory where shared's directory will be mounted
#  $sharedDevice = 'host or ip of the owner of the shared directory'  # Example: 192.168.100.12
#  $sharedPath   = 'shared_directory'                                 # Path of the shared directory
#  # ---------------------------------------------------------
#  # do not modify beyond this line
#  # ---------------------------------------------------------
#  mount { "${mountResourceId}":
#    name    => "${mountPath}",
#    device  => "${sharedDevice}:${sharedPath}",
#    fstype  => 'nfs4',
#    ensure  => 'mounted',
#    options => 'defaults',
#    atboot  => true,
#    require => File[$requiredResourceId],
#  }
#}
class nfs::mount inherits nfs {
  
}

