class packstack::answerfile(
$ssh_key = $packstack::params::ssh_key,
$ntp_server_pool = $packstack::params::ntp_server_pool,
$kvm_compute_host = $packstack::kvm_compute_host,
$network_host = $packstack::network_host,
$vlan_range = $packstack::params::vlan_range,
$cinder_volume_size = $packstack::params::cinder_volume_size,
){

  include packstack::params

  exec {"gen-packstack-answer-file-${name}":
    command => "/usr/bin/packstack  --genanswerfile=${name}",
    creates => "${name}",
  } 

  exec {"set-packstack-ssh-key-${name}":
    command => "openstack-config --set ${name} general CONFIG_SSH_KEY ${ssh_key}.pub",
    require => Exec["gen-packstack-answerfile-${name}"],
  }

  exec {"set-packstack-ntp-pool-${name}":
    command => "openstack-config --set ${name} general CONFIG_NTP_SERVERS ${ntp_server_pool}",
    require => Exec["gen-packstack-answerfile-${name}"],
  }
  exec {"set-packstack-cinder-volume-size-${name}":
    command => "openstack-config --set ${name} general CONFIG_CINDER_VOLUMES_SIZE ${cinder_volume_size}",
    require => Exec["gen-packstack-answerfile-${name}"],
  }
  exec {"set-packstack-kvm-compute-hosts-${name}":
    command => "openstack-config --set ${name} general CONFIG_NOVA_COMPUTE_HOSTS ${kvm_compute_host}",
    require => Exec["gen-packstack-answerfile-${name}"],
  }
  exec {"set-packstack-nova-network-${name}":
    command => "openstack-config --del ${name} general CONFIG_NOVA_NETWORK_HOST",
    require => Exec["gen-packstack-answerfile-${name}"],
  }
  exec {"set-packstack-quantum-l3-hosts-${name}":
    command => "openstack-config --set ${name} general CONFIG_QUANTUM_L3_HOSTS ${network_host}",
    require => Exec["gen-packstack-answerfile-${name}"],
  }
  exec {"set-packstack-quantum-dhcp-hosts-${name}":
    command => "openstack-config --set ${name} general CONFIG_QUANTUM_DHCP_HOSTS ${network_host}",
    require => Exec["gen-packstack-answerfile-${name}"],
  }
  exec {"set-packstack-quantum-metadata-hosts-${name}":
    command => "openstack-config --set ${name} general CONFIG_QUANTUM_METADATA_HOSTS ${network_host}",
    require => Exec["gen-packstack-answerfile-${name}"],
  }
  exec {"set-packstack-quantum-tenant-network-type-${name}":
    command => "openstack-config --set ${name} general CONFIG_QUANTUM_OVS_TENANT_NETWORK_TYPE vlan",
    require => Exec["gen-packstack-answerfile-${name}"],
  }
  exec {"set-packstack-vlan-range-${name}":
    command => "openstack-config --set ${name} general CONFIG_QUANTUM_OVS_VLAN_RANGES physnet1:${vlan_range}",
    require => Exec["gen-packstack-answerfile-${name}"],
  }
  exec {"set-packstack-bridge-mappings-${name}":
    command => "openstack-config --set ${name} general CONFIG_QUANTUM_OVS_BRIDGE_MAPPINGS physnet1:br-eth1",
    require => Exec["gen-packstack-answerfile-${name}"],
  }
  exec {"set-packstack-bridge-interfaces-${name}":
    command => "openstack-config --set ${name} general CONFIG_QUANTUM_OVS_BRIDGE_IFACES br-eth1:eth1",
    require => Exec["gen-packstack-answerfile-${name}"],
  }
}
