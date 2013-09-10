class packstack::packages {

  include packstack::params 

  package {'rdo-release-grizzly':
    ensure   => installed,
    provider => rpm,
    source   => $packstack::params::rdo_release_rpm_url,
  }
  package { $packstack::params::packstack_packages:
    ensure => installed,
    provider => yum,
    require => Package['rdo-release-grizzly']
  }
 package {'python-paramiko':
    ensure   => installed,
    provider => yum,
    source   => Package['python-paramiko'],
  }
}
