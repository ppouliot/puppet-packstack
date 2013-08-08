class packstack::tweaks {

  exec {'quantum_driver_not_set_properly':
    command     => "sed -i 's/^#\ firewall_driver/firewall_driver/g' /etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini",
    notify      => Service['quantum-server'],
    refreshonly => true,
  } 

}
