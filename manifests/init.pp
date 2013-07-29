# == Class: packstack
#
# Full description of class packstack here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { packstack:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class packstack {
#  include vcsrepo
  notify {"your home is ${homedir}":}
  $packstack_requirements = ['tox',
                            ]
  $packstack_dir          = '/opt/packstack'

  package { $packstack_requirements:
    ensure => present,
  } 
if $from_package == 'true' {
  package { 'rdo-release-grizzly':
    provider => rpm,
    source   => 'http://rdo.fedorapeople.org/openstack/openstack-grizzly/rdo-release-grizzly.rpm'
  }   
}

if $from_source == 'true' {
  $packstack_dir = undef
  vcsrepo{ $packstack_dir:
    ensure   => present,
    provider => git,
    source   => "git://github.com/stackforge/packstack"
  }
}

  exec {'gen_packstack_answerfile':
    command => "/usr/bin/python ${packstack_dir}/bin/packstack --gen-answer-file=$packstack_dir/${hostname}.txt", 
    cwd     => $packstack_dir,
    user    => 'root',
    environment => "HOME=/root",
    require => File [ $packstack_dir ],
  }
}
