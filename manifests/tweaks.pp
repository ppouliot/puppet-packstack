# == Class: packstack::tweaks
class packstack::tweaks(
  $kvm_compute_host = $packstack::kvm_compute_host,
  $network_host = $packstack::network_host,
){

  include packstack::params

#  file { "${homedir}/update_server_reboot_compute_node.sh":
#     ensure => present,
#     source => "puppet:///modules/packstack/update_server_reboot_compute_node.sh",
#     mode   => 777
#  }
  exec {'install_centos_release_xen_then_update':
    command   => '/usr/bin/yum install -y centos-release-xen && /usr/bin/yum update -y --disablerepo=* --enablerepo=Xen4CentOS kernel',
#   require   => File ["${homedir}/update_server_reboot_compute_node.sh"],
    logoutput => true,
    timeout   => '0',
  }

#  exec {'quantum_driver_not_set_properly':
#    command     => "/bin/sed -i 's/^#\ firewall_driver/firewall_driver/g' /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini",
#    notify      => Service['quantum-server'],
#    refreshonly => true,
#  }
#  service { 'quantum-server':
#      ensure     => running,
#      enable     => true,
#  } 
# File [ "${homedir}/update_server_reboot_compute_node.sh" ] -> Exec [ "updatekernel" ]
}
