class packstack::network {

  $iface1 = $interface_type ? {
    /(eth)/ => 'eth0', 
    /(em)/  => 'em1', 
  }

  $iface2 = $interface_type ? {
    /(eth)/ => 'eth1', 
    /(em)/  => 'em2', 
  }

  file {"/etc/sysconfig/network-scripts/ifcfg-${iface1}":
    ensure => present,
    content => template('packstack/ifcfg-eth0.erb'),
    notify => service['network'],
  }
  file {"/etc/sysconfig/network-scripts/ifcfg-${iface2}":
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
File["/etc/sysconfig/network-scripts/ifcfg-${iface1}"] ->
  File["/etc/sysconfig/network-scripts/ifcfg-${iface2}"] ->
    File['/etc/sysconfig/network']                         ->
      Service['network']
}
