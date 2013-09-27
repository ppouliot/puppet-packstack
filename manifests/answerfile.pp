define packstack::answerfile(
  $ssh_key = $packstack::params::ssh_key,
  $ntp_server_pool = $packstack::params::ntp_server_pool,
  $kvm_compute_host = $packstack::kvm_compute_host,
  $network_host = $packstack::network_host,
  $vlan_range = $packstack::params::vlan_range,
  $cinder_volume_size = $packstack::params::cinder_volume_size,
){

  include packstack::params

notify { "Here I am ":}
  exec {"gen-packstack-answer-file-${name}":
    command => "/usr/bin/python /usr/bin/packstack --gen-answer-file=${homedir}/${name}",
    cwd     => $homedir,
    user  => 'root',
    creates => "${homedir}/${name}",
  } 
  exec {"set-packstack-ssh-key-${name}":
    command => "/usr/bin/openstack-config  --set ${name} general CONFIG_SSH_KEY ",
    require => Exec["gen-packstack-answer-file-${name}"],
  }
  exec {"set-packstack-ntp-pool-${name}":
    command => "/usr/bin/openstack-config  --set ${name} general CONFIG_NTP_SERVERS ${ntp_server_pool}",
    require => Exec["set-packstack-ssh-key-${name}"],
  }
  exec {"set-packstack-cinder-volume-size-${name}":
    command => "/usr/bin/openstack-config  --set ${name} general CONFIG_CINDER_VOLUMES_SIZE ${cinder_volume_size}",
    require => Exec["set-packstack-ntp-pool-${name}"],
  }
  exec {"set-packstack-kvm-compute-hosts-${name}":
    command => "/usr/bin/openstack-config  --set ${name} general CONFIG_NOVA_COMPUTE_HOSTS ${kvm_compute_host}",
    require => Exec["set-packstack-cinder-volume-size-${name}"],
  }
  exec {"set-packstack-nova-network-${name}":
    command => "/usr/bin/openstack-config  --del ${name} general CONFIG_NOVA_NETWORK_HOST",
    require => Exec["set-packstack-kvm-compute-hosts-${name}"],
  }
  exec {"set-packstack-quantum-l3-hosts-${name}":
    command => "/usr/bin/openstack-config  --set ${name} general CONFIG_QUANTUM_L3_HOSTS ${network_host}",
    require => Exec["set-packstack-nova-network-${name}"],
  }
  exec {"set-packstack-quantum-dhcp-hosts-${name}":
    command => "/usr/bin/openstack-config  --set ${name} general CONFIG_QUANTUM_DHCP_HOSTS ${network_host}",
    require => Exec["set-packstack-quantum-l3-hosts-${name}"],
  }
  exec {"set-packstack-quantum-metadata-hosts-${name}":
    command => "/usr/bin/openstack-config  --set ${name} general CONFIG_QUANTUM_METADATA_HOSTS ${network_host}",
    require => Exec["set-packstack-quantum-dhcp-hosts-${name}"],
  }
  exec {"set-packstack-quantum-tenant-network-type-${name}":
    command => "/usr/bin/openstack-config  --set ${name} general CONFIG_QUANTUM_OVS_TENANT_NETWORK_TYPE vlan",
    require => Exec["set-packstack-quantum-metadata-hosts-${name}"],
  }
  exec {"set-packstack-vlan-range-${name}":
    command => "/usr/bin/openstack-config  --set ${name} general CONFIG_QUANTUM_OVS_VLAN_RANGES physnet1:${vlan_range}",
    require => Exec["set-packstack-quantum-tenant-network-type-${name}"],
  }
  exec {"set-packstack-bridge-mappings-${name}":
    command => "/usr/bin/openstack-config  --set ${name} general CONFIG_QUANTUM_OVS_BRIDGE_MAPPINGS physnet1:br-eth1",
    require => Exec["set-packstack-vlan-range-${name}"],
  }
  exec {"set-packstack-bridge-interfaces-${name}":
    command => "/usr/bin/openstack-config  --set ${name} general CONFIG_QUANTUM_OVS_BRIDGE_IFACES br-eth1:eth1",
    require => Exec["set-packstack-bridge-mappings-${name}"],
  }

   Exec["gen-packstack-answer-file-${name}"] -> Exec["set-packstack-ssh-key-${name}"] -> Exec["set-packstack-ntp-pool-${name}"] -> Exec["set-packstack-cinder-volume-size-${name}"] -> Exec["set-packstack-kvm-compute-hosts-${name}"] -> Exec["set-packstack-nova-network-${name}"] -> Exec["set-packstack-quantum-l3-hosts-${name}"] -> Exec["set-packstack-quantum-dhcp-hosts-${name}"] -> Exec["set-packstack-quantum-metadata-hosts-${name}"] -> Exec["set-packstack-quantum-tenant-network-type-${name}"] -> Exec["set-packstack-vlan-range-${name}"] -> Exec["set-packstack-bridge-mappings-${name}"] -> Exec["set-packstack-bridge-interfaces-${name}"]
}
