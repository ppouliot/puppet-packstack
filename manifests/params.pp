class packstack::params {
  $sshkey_path          = "/root"
  $ssh_pubkey           = "/root/.ssh/id_dsa.pub"
  $answerfile           = "/root/packstack_answers.txt"
  $openstack_release    = 'havana'
  $packstack_packages   = [ 'openstack-packstack','openstack-utils' ]
# $rdo_release_rpm_url  = "http://rdo.fedorapeople.org/openstack/EOL/openstack-${openstack_release}/rdo-release-${openstack_release}.rpm"
  $rdo_release_rpm_url  = "http://rdo.fedorapeople.org/openstack/EOL/openstack-${openstack_release}/rdo-release-9.noarch.rpm"
  $ntp_server_pool      = ['0.pool.ntp.org,1.pool.ntp.org,2.pool.ntp.org,3.pool.ntp.org']
  $vlan_range           = "500:1000"
  $cinder_volume_size   = "5G"
  $openstack_networking = $openstack_release ? {
      /(grizzly)/ => 'QUANTUM',
      default     => 'NEUTRON',
  } 
  $floating_ip_range    = '172.18.2.0/23'
  $public_if            = 'eth2'
}
