class packstack::packages {

  $packstack_packages = [ 'openstack-packstack','openstack-utils' ]

  package {'rdo-release-grizzly':
    ensure   => installed,
    provider => rpm,
    source   => 'http://rdo.fedorapeople.org/openstack/openstack-grizzly/rdo-release-grizzly.rpm',
  }

  package { $packstack_packages:
    ensure => installed,
    provider => yum,
    require => Package['rdo-release-grizzly']
  }
}
