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
  file { 'hadoop_webapp_static_dir':
    path    => '/home/hdadmin/software/hadoop-1.2.1/webapps/static',
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
  
  file { 'hadoop_static_banner':
    path    => '/home/hdadmin/software/hadoop-1.2.1/webapps/static/banner.jpg',
    source  => 'puppet:///modules/hadoop/webapps/static/banner.jpg',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_webapp_static_dir'],
  }
  file { 'hadoop_static_logo':
    path    => '/home/hdadmin/software/hadoop-1.2.1/webapps/static/hadoop-logo.jpg',
    source  => 'puppet:///modules/hadoop/webapps/static/hadoop-logo.jpg',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_webapp_static_dir'],
  }
  file { 'hadoop_static_css':
    path    => '/home/hdadmin/software/hadoop-1.2.1/webapps/static/hadoop.css',
    source  => 'puppet:///modules/hadoop/webapps/static/hadoop.css',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_webapp_static_dir'],
  }
  file { 'hadoop_static_jobconf.xsl':
    path    => '/home/hdadmin/software/hadoop-1.2.1/webapps/static/jobconf.xsl',
    source  => 'puppet:///modules/hadoop/webapps/static/jobconf.xsl',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_webapp_static_dir'],
  }
  file { 'hadoop_static_jt.js':
    path    => '/home/hdadmin/software/hadoop-1.2.1/webapps/static/jobtracker.js',
    source  => 'puppet:///modules/hadoop/webapps/static/jobtracker.js',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_webapp_static_dir'],
  }
  file { 'hadoop_static_sorttable.js':
    path    => '/home/hdadmin/software/hadoop-1.2.1/webapps/static/sorttable.js',
    source  => 'puppet:///modules/hadoop/webapps/static/sorttable.js',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_webapp_static_dir'],
  }
}

class hadoop::master {
  
  include master_node
  include hadoop
  
  # DATA LOCATIONS:
  file { 'hadoop_folder':
    path    => '/hadoop',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => User['hdadmin'],
  }
  file { 'hadoop_master_tmp':
    path    => '/data01/hadoop/tmp',
    ensure  => directory,
    mode    => '0775',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['/data01'],
  }
}

class hadoop::master::nn inherits hadoop::master {
  file { 'hadoop_dfs':
    path    => '/data01/hadoop/dfs',
    ensure  => directory,
    mode    => '0775',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hadoop_folder'],
  }
  ## TODO Uncomment inclusion for applying mount class
  #include hadoop::master::mount_data01_hadoop_nn_mirror
  ## Ensure that mountPath directory exists
  #file { 'nfs_nn_mirror':
  #  path    => '/data01/hadoop/dfs/nfs_nn_mirror',
  #  ensure  => directory,
  #  mode    => '0775',
  #  owner   => 'hdadmin',
  #  group   => 'hadoop',
  #  require => File['hadoop_dfs'],
  #}
}
# TODO It's not working as expected. Temporarily disabled
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
  # TODO REVISAR ESTO!
  exec { "$execResourceId":
    unless  => "/bin/cat /proc/mounts | /bin/egrep -c '^${sharedDevice}':'${mountPath}[ ]' | /bin/egrep -c '^1'",
    command => "/bin/mount -t nfs4 ${sharedDevice}:${sharedPath} ${mountPath}",
    require  => File[$requiredResourceId],
  }
  # \ TODO REVISAR ESTO!
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
# -------------------------------------------------------------------------------------------------
# Hadoop slave node
# -------------------------------------------------------------------------------------------------
class hadoop::slave {
  
  include worker_node
  include hadoop
  
  # DATA LOCATIONS:
  file { 'data01_hadoop':
    path    => '/data01/hadoop',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => [ File['data01'], User['hdadmin'] ],
  }
  file { 'data02_hadoop':
    path    => '/data02/hadoop',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => [ File['data02'], User['hdadmin'] ],
  }
  file { 'data03_hadoop':
    path    => '/data03/hadoop',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => [ File['data03'], User['hdadmin'] ],
  }
  file { 'data04_hadoop':
    path    => '/data04/hadoop',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => [ File['data04'], User['hdadmin'] ],
  }
  file { 'data05_hadoop':
    path    => '/data05/hadoop',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => [ File['data05'], User['hdadmin'] ],
  }
  file { 'data06_hadoop':
    path    => '/data06/hadoop',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => [ File['data06'], User['hdadmin'] ],
  }
}
# -------------------------------------------------------------------------------------------------
# Mirror for namenode's metadata
# -------------------------------------------------------------------------------------------------
class hadoop::nn_mirror {
  include hadoop::share_data01_hadoop_nn_mirror
  # Ensure that sharedPath directory exists
  file { 'nn_mirror':
    path    => '/data01/hadoop/nn_mirror',
    ensure  => directory,
    mode    => '0775',
    owner   => 'hdadmin',
    group   => 'hadoop',
    #require => File['hadoop_folder'], # <- for real
    require => File['data01_hadoop'],  # <- for virtual
  }
}
# Shares a directory using nfs
class hadoop::share_data01_hadoop_nn_mirror inherits nfs::share {
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
# -------------------------------------------------------------------------------------------------
# Hive Server
# -----------
# To Start hiveserver:
# [@shared02] cd /home/mysql/runtime/mysql && nohup ./bin/mysqld_safe --defaults-file=/home/mysql/.my.cnf --port=3306 --socket=/data01/mysql/mysql.sock --datadir=/data01/mysql/data --log-error=/data01/mysql/logs/mysqld.log --pid-file=/data01/mysql/mysqld.pid >> /data01/mysql/logs/mysqld_nohup &
# [@master01] su - hdadmin -c "nohup /home/hdadmin/runtime/hive/bin/hive --service metastore  >> /data01/hive/logs/nohup_metastore.out &"
# [@master01] su - hdadmin -c "nohup /home/hdadmin/runtime/hive/bin/hive --service hiveserver >> /data01/hive/logs/nohup_hiveserver.out &"
# -------------------------------------------------------------------------------------------------
class hadoop::hiveserver {
  
  include hadoop
  
  file { 'install-hiveserver':
    path   => '/root/install-hiveserver.sh',
    source => 'puppet:///modules/hadoop/root/install-hiveserver.sh',
    mode   => '0700',
  }
  
  exec { 'do-install-hiveserver':
    command => '/root/install-hiveserver.sh > /root/hiveserver-install.log',
    creates => '/root/hiveserver-installed-by-puppet',
    require => [
      File['install-hiveserver', 'hdsoftware', 'hdruntime'],
      User['hdadmin'],
      Package['tftp'],
    ],
  }
  file { 'hiveserver-installed.flag':
    path => '/root/hiveserver-installed-by-puppet',
    require => Exec['do-install-hiveserver'],
  }
  
  file { 'hiveserver_conf_dir':
    path    => '/home/hdadmin/software/hive-0.13.1/conf',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hiveserver-installed.flag'],
  }
  
  # CONFIG FILES:
  file { 'hive-env.sh':
    path    => '/home/hdadmin/software/hive-0.13.1/conf/hive-env.sh',
    source  => 'puppet:///modules/hadoop/hive-0.13.1/conf/hive-env.sh',
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hiveserver_conf_dir'],
  }
  file { 'hive-exec-log4j.properties':
    path    => '/home/hdadmin/software/hive-0.13.1/conf/hive-exec-log4j.properties',
    source  => 'puppet:///modules/hadoop/hive-0.13.1/conf/hive-exec-log4j.properties',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hiveserver_conf_dir'],
  }
  file { 'hive-log4j.properties':
    path    => '/home/hdadmin/software/hive-0.13.1/conf/hive-log4j.properties',
    source  => 'puppet:///modules/hadoop/hive-0.13.1/conf/hive-log4j.properties',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hiveserver_conf_dir'],
  }
  file { 'hive-site.xml':
    path    => '/home/hdadmin/software/hive-0.13.1/conf/hive-site.xml',
    source  => 'puppet:///modules/hadoop/hive-0.13.1/conf/hive-site.xml',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hiveserver_conf_dir'],
  }
  
  # DATA LOCATIONS:
  file { 'data01_hive':
    path    => '/data01/hive',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => [ File['/data01'], User['hdadmin'] ],
  }
  file { 'hive_tmp':
    path    => '/data01/hive/tmp',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['data01_hive'],
  }
  file { 'hive_logs':
    path    => '/data01/hive/logs',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['data01_hive'],
  }
}
# -------------------------------------------------------------------------------------------------
# HBase for Hadoop1
# -------------------------------------------------------------------------------------------------
class hadoop::hbase1 {
  
  include hadoop
  
  file { 'install-hbase1':
    path   => '/root/install-hbase1.sh',
    source => 'puppet:///modules/hadoop/root/install-hbase1.sh',
    mode   => '0700',
  }
  
  exec { 'do-install-hbase1':
    command => '/root/install-hbase1.sh > /root/hbase1-install.log',
    creates => '/root/hbase1-installed-by-puppet',
    require => [
      File['install-hbase1', 'hdsoftware', 'hdruntime'],
      User['hdadmin'],
      Package['tftp'],
    ],
  }
  file { 'hbase1-installed.flag':
    path => '/root/hbase1-installed-by-puppet',
    require => Exec['do-install-hbase1'],
  }
  
  file { 'hbase1_conf_dir':
    path    => '/home/hdadmin/software/hbase-0.98.3-hadoop1/conf',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hbase1-installed.flag'],
  }
  
  # CONFIG FILES:
  file { 'hbase1-hadoop-metrics2.properties':
    path    => '/home/hdadmin/software/hbase-0.98.3-hadoop1/conf/hadoop-metrics2-hbase.properties',
    source  => 'puppet:///modules/hadoop/hbase1-0.98.3/conf/hadoop-metrics2-hbase.properties',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hbase1_conf_dir'],
  }
  file { 'hbase1-env.sh':
    path    => '/home/hdadmin/software/hbase-0.98.3-hadoop1/conf/hbase-env.sh',
    source  => 'puppet:///modules/hadoop/hbase1-0.98.3/conf/hbase-env.sh',
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hbase1_conf_dir'],
  }
  file { 'hbase1-policy.xml':
    path    => '/home/hdadmin/software/hbase-0.98.3-hadoop1/conf/hbase-policy.xml',
    source  => 'puppet:///modules/hadoop/hbase1-0.98.3/conf/hbase-policy.xml',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hbase1_conf_dir'],
  }
  file { 'hbase1-site.xml':
    path    => '/home/hdadmin/software/hbase-0.98.3-hadoop1/conf/hbase-site.xml',
    source  => 'puppet:///modules/hadoop/hbase1-0.98.3/conf/hbase-site.xml',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hbase1_conf_dir'],
  }
  file { 'hbase1-log4j.properties':
    path    => '/home/hdadmin/software/hbase-0.98.3-hadoop1/conf/log4j.properties',
    source  => 'puppet:///modules/hadoop/hbase1-0.98.3/conf/log4j.properties',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hbase1_conf_dir'],
  }
  file { 'hbase1-regionservers':
    path    => '/home/hdadmin/software/hbase-0.98.3-hadoop1/conf/regionservers',
    source  => 'puppet:///modules/hadoop/hbase1-0.98.3/conf/regionservers',
    mode    => '0644',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => File['hbase1_conf_dir'],
  }
}
# Only for semantics. Not sure it's needed
class hadoop::hbase1::htable {
  
  include hadoop::hbase1
  
  # DATA LOCATIONS:
  file { 'data01_hbase1':
    path    => '/data01/hbase',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => [ File['data01'], User['hdadmin'] ],
  }
}
# This class should be applied on a "master" server. It is where HBase will be started/stoped from
class hadoop::hbase1::master {
  
  include hadoop::hbase1
  
  # DATA LOCATIONS:
  file { 'data01_hbase1':
    path    => '/data01/hbase',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => [ File['/data01'], User['hdadmin'] ],
  }
}
# Ensure you include each node you apply this class to in regionservers file
class hadoop::hbase1::regionserver {
  
  include hadoop::hbase1
  
  # DATA LOCATIONS:
  file { 'data01_hbase1':
    path    => '/data01/hbase',
    ensure  => directory,
    mode    => '0755',
    owner   => 'hdadmin',
    group   => 'hadoop',
    require => [ File['data01'], User['hdadmin'] ],
  }
}