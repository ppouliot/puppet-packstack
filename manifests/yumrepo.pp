# == Class: packstack::yumrepo
class packstack::yumrepo {

  $openstack_release = $packstack::params::openstack_release

  include packstack::params

  package {'puppetlabs-release':
    ensure   => absent,
    provider => rpm,
    source   => $packstack::params::rdo_release_rpm_url,
  }

  package {"rdo-release-${openstack_release}-rpm":
    ensure   => installed,
    name     => "rdo-release-${openstack_release}",
    provider => rpm,
    source   => $packstack::params::rdo_release_rpm_url,
    require  => Package['puppetlabs-release'],
  }

  file {'/etc/yum.repos.d/epel.repo':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/packstack/epel.repo',
    require => Package["rdo-release-${openstack_release}-rpm"],
  }

}
