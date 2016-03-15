# == Class: packstack::packages
class packstack::packages () inherits packstack::params {
  $openstack_release = $packstack::params::openstack_release
#  package {"rdo-release-${openstack_release}-yum":
#    name     => "rdo-release-${openstack_release}",
#    ensure   => latest,
#    provider => yum,
#    require => Class['packstack::yumrepo']
#  }

  package { $packstack::params::packstack_packages:
    ensure   => latest,
    provider => yum,
    require  => Package["rdo-release-${openstack_release}"]
  }

}
