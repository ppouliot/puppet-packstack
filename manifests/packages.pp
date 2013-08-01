class {'packstack::packages':


  package{'rdo-release-grizzly':
    ensure => installed,
    provider => rpm,
    url => 'http://rdo.fedorapeople.org/openstack/openstack-grizzly/rdo-release-grizzly.rpm',
  }

  $packstack_packages = ['openstack-packstack',
                         'openstack-utils'],

  package{ $packstack_packages:
    ensure => installed,
  }

}
