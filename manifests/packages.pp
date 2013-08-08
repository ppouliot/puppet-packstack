class packstack::packages {

  include packstack::params 

  package {'rdo-release-grizzly':
    ensure   => installed,
    provider => rpm,
    source   => $rdo_release_rpm_url,
  }

  package { $packstack_packages:
    ensure => installed,
    provider => yum,
    require => Package['rdo-release-grizzly']
  }
}
