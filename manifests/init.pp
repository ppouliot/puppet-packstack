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

  $kvm_compute_host = "192.168.100.188"
  $network_host = "192.168.100.172"
  $controller_host = "192.168.100.237"
  include packstack::params

  notify {"your home is ${homedir}":}
  notify {"your gateway is ${default_gateway}":}

  $packstack_src = '/usr/local/src/packstack'

  vcsrepo{ $packstack_src:
    ensure   => present,
    provider => git,
    source   => "git://github.com/stackforge/packstack"
  }

  #exec {'gen_packstack_answerfile':
    #command => "/usr/bin/python ${packstack_src}/bin/packstack --gen-answer-file=${packstack_src}/${hostname}.txt", 
    #cwd     => $packstack_src,
    #user    => 'root',
    #environment => "HOME=/root",
    #require => Vcsrepo[ $packstack_src ],
  #}
  #class { 'packstack::answerfile' : name => 'packstack_answers.conf'}   
#class{'packstack::answerfile':} 

  class{'packstack::sshkeygen':}
  class{'packstack::network':}
  class{'packstack::packages':}
  class{ 'packstack::answerfile' : name => 'packstack_answers.conf'}
  class{'packstack::tweaks':}
  class{'packstack::openvswitch':}

exec {'install_packstack':
    command => "/usr/bin/python /usr/bin/packstack --answer-file=${homedir}/packstack_answers.conf",
    cwd     => $homedir,
    user    => "root",
    environment => "HOME=/root",
    timeout => 1500,
    logoutput => true,
    require => package[$packstack::params::packstack_packages],
 }


 Class['packstack::network'] -> 
  Class['packstack::packages'] -> 
   Class['packstack::sshkeygen'] ->
    Class['packstack::answerfile'] -> 
     Exec ['install_packstack']  ->
      Class['packstack::tweaks'] ->
       Class['packstack::openvswitch']
}
