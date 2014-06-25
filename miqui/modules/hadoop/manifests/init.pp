class hadoop {
  
  group { 'hadoop':
    ensure => present,
  }
  user { 'hdadmin':
    ensure     => present,
    gid        => 'hadoop',
    managehome => true,
    home       => '/home/hdadmin',
    shell      => '/bin/bash',
    require    => Group['hadoop'],
  }
  file { 'hdadmin_home':
    path    => '/home/hdadmin',
    ensure  => directory,
    mode    => '0750',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => User['hdadmin'],
  }
  file { 'hdsoftware':
    path    => '/home/hdadmin/software',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hdadmin_home'],
  }
  file { 'hdruntime':
    path    => '/home/hdadmin/runtime',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hdadmin_home'],
  }
  file { 'bashrc':
    path    => '/home/hdadmin/.bashrc',
    source  => 'puppet:///modules/hadoop/home/hdadmin/.bashrc',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hdadmin_home'],
  }
  file { 'hdadmin_ssh_dir':
    path   => '/home/hdadmin/.ssh',
    ensure => 'directory',
    mode   => '0700',
    owner  => 'hdadmin',
    group  => 'hadoop',
    require => File['hdadmin_home'],
  }
  file { 'hdadmin_known_hosts':
    path   => '/home/hdadmin/.ssh/known_hosts',
    source => 'puppet:///modules/hadoop/home/hdadmin/.ssh/known_hosts',
    mode   => '0644',
    owner  => 'hdadmin',
    group  => 'hadoop',
    require => File['hdadmin_ssh_dir'],
  }
  file { 'hdadmin_authorized_keys':
    path   => '/home/hdadmin/.ssh/authorized_keys',
    source => 'puppet:///modules/hadoop/home/hdadmin/.ssh/authorized_keys',
    mode   => '0600',
    owner  => 'hdadmin',
    group  => 'hadoop',
    require => File['hdadmin_ssh_dir'],
  }
  service { 'iptables':
    ensure => stopped,
  }
  service { 'ip6tables':
    ensure => stopped,
  }
  file { 'install-java':
    path   => '/root/install-java.sh',
    source => 'puppet:///modules/hadoop/root/install-java.sh',
    mode   => '0700',
  }
  file { 'install-hadoop':
    path   => '/root/install-hadoop.sh',
    source => 'puppet:///modules/hadoop/root/install-hadoop.sh',
    mode   => '0700',
  }
  
  exec { 'do-install-java':
    command => '/root/install-java.sh > /root/java-install.log',
    creates => '/root/java-installed-by-puppet',
    require => [
      File['install-java', 'hdsoftware', 'hdruntime'],
      User['hdadmin'],
      Package['tftp'],
      Service['iptables'],
    ],
  }
  exec { 'do-install-hadoop':
    command => '/root/install-hadoop.sh > /root/hadoop-install.log',
    creates => '/root/hadoop-installed-by-puppet',
    require => [
      File['install-hadoop', 'hdsoftware', 'hdruntime'],
      User['hdadmin'],
      Package['tftp'],
      Service['iptables'],
    ],
  }
  file { 'java-installed.flag':
    path => '/root/java-installed-by-puppet',
    require => Exec['do-install-java'],
  }
  file { 'hadoop-installed.flag':
    path => '/root/hadoop-installed-by-puppet',
    require => Exec['do-install-hadoop'],
  }
  
  file { 'hadoop_conf_dir':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop-installed.flag'],
  }
  
  # CONFIG FILES:
  file { 'capacity-scheduler':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/capacity-scheduler.xml',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/capacity-scheduler.xml',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
  file { 'configuration':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/configuration.xsl',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/configuration.xsl',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
  file { 'core-site':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/core-site.xml',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/core-site.xml',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
  file { 'excluded-nodes':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/excluded-nodes',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/excluded-nodes',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
  file { 'fair-scheduler':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/fair-scheduler.xml',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/fair-scheduler.xml',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
  file { 'hadoop-env':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/hadoop-env.sh',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/hadoop-env.sh',
    mode    => '0644',      # XXX wouldn't they want to execute?
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
  file { 'hadoop-metrics2':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/hadoop-metrics2.properties',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/hadoop-metrics2.properties',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
  file { 'hadoop-policy':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/hadoop-policy.xml',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/hadoop-policy.xml',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
  file { 'hdfs-site':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/hdfs-site.xml',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/hdfs-site.xml',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
  file { 'included-nodes':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/included-nodes',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/included-nodes',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
  file { 'log4j':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/log4j.properties',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/log4j.properties',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
  file { 'mapred-queue-acls':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/mapred-queue-acls.xml',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/mapred-queue-acls.xml',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
  file { 'mapred-site':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/mapred-site.xml',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/mapred-site.xml',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
  file { 'masters':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/masters',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/masters',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
  file { 'slaves':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/slaves',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/slaves',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
  file { 'ssl-client.xml.example':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/ssl-client.xml.example',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/ssl-client.xml.example',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
  file { 'ssl-server.xml.example':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/ssl-server.xml.example',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/ssl-server.xml.example',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
  file { 'task-log4j':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/task-log4j.properties',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/task-log4j.properties',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
  file { 'taskcontroller':
    path    => '/home/hdadmin/software/hadoop-1.2.1/conf/taskcontroller.cfg',
    source  => 'puppet:///modules/hadoop/1.2.1/conf/taskcontroller.cfg',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_conf_dir'],
  }
}

class hadoop::master::nn {
  include hadoop::master::mount_data01_hadoop_nn_mirror
  # Ensure that mountPath directory exists
  file { 'hadoop_dfs':
    path    => '/data01/hadoop/dfs',
    ensure  => directory,
    mode    => '0775',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_folder'],
  }
  file { 'nfs_nn_mirror':
    path    => '/data01/hadoop/dfs/nfs_nn_mirror',
    ensure  => directory,
    mode    => '0775',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_dfs'],
  }
  
}
class hadoop::master::nn_mirror {
  include hadoop::master::share_data01_hadoop_nn_mirror
  # Ensure that sharedPath directory exists
  file { 'nn_mirror':
    path    => '/data01/hadoop/nn_mirror',
    ensure  => directory,
    mode    => '0775',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['data01_hadoop'],
  }
}

# Shares a directory using nfs
class hadoop::master::share_data01_hadoop_nn_mirror inherits nfs::share {
  $execResourceId = 'do-share-data01_hadoop_nn_mirror'
  $requiredResourceId = 'nn_mirror'
  $sharedPath = '/data01/hadoop/nn_mirror'
  $sharedTo   = '192.168.1.0/24'
  $mode       = 'rw'
  $syncmode   = 'async'
  # ---------------------------------------------------------
  # do not modify beyond this line
  # ---------------------------------------------------------
  exec { "$execResourceId":
    onlyif  => "/bin/egrep -c -v '^${sharedPath}[ ]' /etc/exports",
    command => "/bin/echo ${sharedPath} ${sharedTo}'('${mode},${syncmode}')' >> /etc/exports",
    require => [
      Exec['do-reset-exports-list'],
      File[$requiredResourceId]
    ],
  }
  Exec["$execResourceId"] -> Exec['exportfs']
}

# Mounts an existing external shared folder...
class hadoop::master::mount_data01_hadoop_nn_mirror inherits nfs::mount {
  $mountResourceId = 'mount-data01_hadoop_nn_mirror'
  $execResourceId  = 'do-mount-data01_hadoop_nn_mirror'
  $requiredResourceId = 'nfs_nn_mirror'
  $mountPath = '/data01/hadoop/dfs/nfs_nn_mirror'
  $sharedDevice = 'worker01.bigdata'
  $sharedPath   = '/data01/hadoop/nn_mirror'
  # ---------------------------------------------------------
  # do not modify beyond this line
  # ---------------------------------------------------------

  exec { "$execResourceId":
    unless  => "/bin/cat /proc/mounts | /bin/egrep -c '^${sharedDevice}':'${mountPath}[ ]' | /bin/egrep -c '^1'",
    command => "/bin/mount -t nfs4 ${sharedDevice}:${sharedPath} ${mountPath}",
    require  => File[$requiredResourceId],
  }
  mount { "$mountResourceId":
    name     => "${mountPath}",
    device   => "${sharedDevice}:${sharedPath}",
    fstype   => 'nfs4',
    ensure   => 'mounted',
    options  => 'remount',
    atboot   => true,
    require  => Exec[$execResourceId],
  }
}
