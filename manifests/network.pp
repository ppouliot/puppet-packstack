class packstack::network {

  file {'/etc/sysconfig/network-scripts/ifcfg-eth0':
    ensure => present,
    content => template(packstack/ifcfg-eth0.erb),
  }
  file {'/etc/sysconfig/network-scripts/ifcfg-eth1':
    ensure => present,
    content => "puppet:///packstack/ifcfg-eth1",
  }

  file {'/etc/sysconfig/network':
    ensure => present,
    content => template(packstack/network.erb),
  }

  file {'/etc/resolv.conf'
    ensure => present,
    content => ['nameserver 10.21.7.1
nameserver 10.21.7.2'],
  }



}
