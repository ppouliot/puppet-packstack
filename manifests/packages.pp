class packstack::packages {

  $openstack_release = $packstack::params::openstack_release

  include packstack::params 

#  package {"rdo-release-${openstack_release}-yum":
#    name     => "rdo-release-${openstack_release}",
#    ensure   => latest,
#    provider => yum,
#    require => Package["rdo-release-${openstack_release}"]
#  }

  package { $packstack::params::packstack_packages:
    ensure => latest,
    provider => yum,
    require => Package["rdo-release-${openstack_release}"]
  }

}
