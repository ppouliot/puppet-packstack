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
class packstack ( $kvm_compute_host,$network_host,$controller_host){

  include packstack::params

  notify {"your home is ${homedir}":}
  notify {"your gateway is ${default_gateway}":}

  $packstack_src = '/usr/local/src/packstack'

if $hostname == 'openstack-controller' {

  vcsrepo{ $packstack_src:
    ensure   => present,
    provider => git,
    source   => "git://github.com/stackforge/packstack"
  }

  exec {'generate_packstack_answerfile_from_source':
    command => "/usr/bin/python ${packstack_src}/bin/packstack --gen-answer-file=${packstack_src}/${hostname}.txt", 
    cwd     => $packstack_src,
    user    => 'root',
    environment => "HOME=/root",
    require => Vcsrepo[ $packstack_src ],
  }

class{'packstack::answerfile':}

}

  class{'packstack::network':}
  class{'packstack::packages':}
  class{'packstack::tweaks':}
#  class{'packstack::openvswitch':}


 Class['packstack::network'] -> 
  Class['packstack::packages']  -> 
   Class['packstack::answerfile'] -> 
      Class['packstack::tweaks'] #->
#       Class['packstack::openvswitch']
}
