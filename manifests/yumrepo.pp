class packstack::yumrepo {

  $openstack_release = $packstack::params::openstack_release

  include packstack::params 

  package {'puppetlabs-release':
    ensure   => absent,
    provider => rpm,
    source   => $packstack::params::rdo_release_rpm_url,
  }


  package {"rdo-release-${openstack_release}-rpm":
    name     => "rdo-release-${openstack_release}",
    ensure   => installed,
    provider => rpm,
    source   => $packstack::params::rdo_release_rpm_url,
    require  => Package['puppetlabs-release'],
  }

}
