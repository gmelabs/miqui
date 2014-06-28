class ntp {
  package { 'ntp':
    ensure => installed,
  }
  package { 'ntpdate':
    ensure => installed,
  }
  file { 'ntp.conf':
    path   => '/etc/ntp.conf',
    source => 'puppet:///modules/ntp/etc/ntp.conf',
    owner  => root,
    group  => root,
    mode   => '0644',
  }
  file { 'step-tickers':
    path   => '/etc/ntp/step-tickers',
    source => 'puppet:///modules/ntp/etc/ntp/step-tickers',
    owner  => root,
    group  => root,
    mode   => '0644',
  }
  service { 'ntpd':
    ensure  => running,
    enable  => true,
    require => [
      Package['ntp', 'ntpdate'],
      File['ntp.conf', 'step-tickers']
    ]
  }
  
}