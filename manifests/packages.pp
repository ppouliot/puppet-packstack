class packstack::packages {

  include packstack::params 

  package {"rdo-release-${openstack_release}":
    ensure   => latest,
    provider => rpm,
    source   => $packstack::params::rdo_release_rpm_url,
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
