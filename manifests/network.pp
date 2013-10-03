class packstack::network {

  if $interface_type == 'eth' {
    $iface1 = 'eth0' 
    $iface2 = 'eth1' 
  }

  if $interface_type == 'em' {
    $iface1 = 'em1' 
    $iface2 = 'em2' 
  }

  file {'/etc/sysconfig/network-scripts/ifcfg-${iface1}":
    ensure => present,
    content => template('packstack/ifcfg-eth0.erb'),
    notify => service['network'],
  }
  file {'/etc/sysconfig/network-scripts/ifcfg-${iface2}":
    ensure => present,
    content => template('packstack/ifcfg-eth1.erb'),
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
domain openstack.tld
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
    subscribe => File["/etc/sysconfig/network-scripts/ifcfg-${iface1}",
                      "/etc/sysconfig/network-scripts/ifcfg-${iface2}",
                      '/etc/sysconfig/network','/etc/resolv.conf'],
  }
File['/etc/sysconfig/network-scripts/ifcfg-eth0'] ->
  File['/etc/sysconfig/network-scripts/ifcfg-eth1'] ->
    File['/etc/sysconfig/network']->Service['network']
}
