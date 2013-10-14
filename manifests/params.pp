class packstack::params {
  $sshkey_path         = "/root"
  $ssh_pubkey          = "${homedir}/.ssh/id_rsa"
  $answerfile          = "/root/packstack_answers.txt"
  $openstack_release   = havana
  $packstack_packages  = [ 'openstack-packstack','openstack-utils' ]
  $rdo_release_rpm_url = "http://rdo.fedorapeople.org/openstack/openstack-${openstack_release}/rdo-release-${openstack_release}.rpm"
  $ntp_server_pool     = ['0.pool.ntp.org,1.pool.ntp.org,2.pool.ntp.org,3.pool.ntp.org']
  $vlan_range          = "500-1000"
  $cinder_volume_size  = "5G"
}
