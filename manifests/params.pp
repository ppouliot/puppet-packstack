class packstack::params {
  $sshkey_path = "/root"
  $ssh_pubkey = "${homedir}/.ssh/id_rsa"
  $packstack_packages = [ 'openstack-packstack','openstack-utils' ]
  $rdo_release_rpm_url = "http://rdo.fedorapeople.org/openstack/openstack-grizzly/rdo-release-grizzly.rpm"
  $ntp_server_pool     = ['0.pool.ntp.org,1.pool.ntp.org,2.pool.ntp.org,3.pool.ntp.org']
  $vlan_range = "500-1000"
  $cinder_volume_size = "5G"
  $answerfile = "/root/packstack_answers.txt"
}
