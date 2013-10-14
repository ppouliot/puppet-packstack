class packstack::packages {

  $openstack_release = $packstack::params::openstack_release

  include packstack::params 

  package {'puppetlabs-release':
    ensure   => absent,
    provider => rpm,
    source   => $packstack::params::rdo_release_rpm_url,
  }


  package {"rdo-release-${openstack_release}":
    ensure   => latest,
    provider => rpm,
    source   => $packstack::params::rdo_release_rpm_url,
    require  => Package['puppetlabs-release'],
  }

  package { $packstack::params::packstack_packages:
    ensure => latest,
    provider => yum,
    require => Package["rdo-release-${openstack_release}"]
  }

  package {['python-paramiko','python-netaddr']:
    ensure   => latest,
    provider => yum,
  }
}
