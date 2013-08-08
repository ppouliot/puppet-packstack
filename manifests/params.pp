class packstack::params {

  $sshkey_path = "/root"
  $ssh_pubkey = "/root/.ssh/id_dsa"
  $packstack_packages = [ 'openstack-packstack','openstack-utils' ]
  $rdo_release_rpm_url = "http://rdo.fedorapeople.org/openstack/openstack-grizzly/rdo-release-grizzly.rpm"
  $ntp_server_pool     = ['bonehed.lcs.mit.edu']
  $vlan_range = "500-1000"
  $cinder_volume_size = "5G"


}
