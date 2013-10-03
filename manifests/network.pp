class packstack::network {

  file {'/etc/sysconfig/network-scripts/ifcfg-em1':
    ensure => present,
    content => template('packstack/ifcfg-em1.erb'),
    notify => service['network'],
  }
  file {'/etc/sysconfig/network-scripts/ifcfg-em2':
    ensure => present,
    source => "puppet:///modules/packstack/ifcfg-em2",
    notify => service['network'],
  }

  file {'/etc/sysconfig/network':
    ensure => present,
    content => template('packstack/network.erb'),
    notify => service['network'],
  }

  file {'/etc/resolv.conf':
    ensure => present,
    notify => service['network'],
    content => ["
search openstack.tld
nameserver 10.21.7.1
nameserver 10.21.7.2
"],


  }
  service { 'network':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    subscribe => File['/etc/sysconfig/network-scripts/ifcfg-em1',
                      '/etc/sysconfig/network-scripts/ifcfg-em2',
                      '/etc/sysconfig/network','/etc/resolv.conf'],
  }
File['/etc/sysconfig/network-scripts/ifcfg-em1'] ->
  File['/etc/sysconfig/network-scripts/ifcfg-em2'] ->
    File['/etc/sysconfig/network']->Service['network']
}
