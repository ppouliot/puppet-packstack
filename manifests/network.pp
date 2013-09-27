class packstack::network {

  file {'/etc/sysconfig/network-scripts/ifcfg-eth0':
    ensure => present,
    content => template('packstack/ifcfg-eth0.erb'),
    notify => service['network'],
  }
  file {'/etc/sysconfig/network-scripts/ifcfg-eth1':
    ensure => present,
    source => "puppet:///modules/packstack/ifcfg-eth1",
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
    subscribe => File['/etc/sysconfig/network-scripts/ifcfg-eth0',
                      '/etc/sysconfig/network-scripts/ifcfg-eth1',
                      '/etc/sysconfig/network','/etc/resolv.conf'],
  }
File['/etc/sysconfig/network-scripts/ifcfg-eth0'] ->
  File['/etc/sysconfig/network-scripts/ifcfg-eth1'] ->
    File['/etc/sysconfig/network']->Service['network']
}
