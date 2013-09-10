class packstack::tweaks(
$kvm_compute_host = $packstack::kvm_compute_host,
$network_host = $packstack::network_host,
){

  include packstack::params

  file { "${homedir}/update_server_reboot_compute_node.sh":
     ensure => present,
     source => "puppet:///modules/packstack/update_server_reboot_compute_node.sh",
     mode => 777
  }
  exec {'updatekernel':
    command => "${homedir}/update_server_reboot_compute_node.sh ${network_host} ${kvm_compute_host}",
    require => File ["${homedir}/update_server_reboot_compute_node.sh"],
    timeout => 1000,
  } 

  exec {'quantum_driver_not_set_properly':
    command     => "/bin/sed -i 's/^#\ firewall_driver/firewall_driver/g' /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini",
    notify      => Service['quantum-server'],
    refreshonly => true,
  }
  service { 'quantum-server':
      ensure     => running,
      enable     => true,
  } 
 File [ "${homedir}/update_server_reboot_compute_node.sh" ] -> Exec [ "updatekernel" ]
}
