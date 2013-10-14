class packstack::answerfile(

  $ssh_pubkey = $packstack::params::ssh_pubkey,
  $ntp_server_pool = $packstack::params::ntp_server_pool,
  $kvm_compute_host = $packstack::kvm_compute_host,
  $network_host = $packstack::network_host,
  $vlan_range = $packstack::params::vlan_range,
  $cinder_volume_size = $packstack::params::cinder_volume_size,
  $answerfile         = $packstack::params::answerfile

){

  include packstack::params

  exec {"gen-packstack-answer-file":
    command => "/usr/bin/python /usr/bin/packstack --gen-answer-file=${answerfile}",
    cwd     => '/root',
    user  => 'root',
    environment => "HOME=/root",
    #require => Package[$packstack::params::packstack_packages]
    require => Class['packstack::packages']
  } 

  exec {"set-packstack-ssh-key":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_SSH_KEY ${ssh_pubkey}",
    cwd     => '/root',
    require => Exec["gen-packstack-answer-file"],
  }

  exec {"set-packstack-ntp-pool":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_NTP_SERVERS ${ntp_server_pool}",
    require => Exec["set-packstack-ssh-key"],
  }
  exec {"set-packstack-cinder-volume-size":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_CINDER_VOLUMES_SIZE ${cinder_volume_size}",
    require => Exec["set-packstack-ntp-pool"],
  }
  exec {"set-packstack-kvm-compute-hosts":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_NOVA_COMPUTE_HOSTS ${kvm_compute_host}",
    require => Exec["set-packstack-cinder-volume-size"],
  }
  exec {"set-packstack-nova-network":
    command => "/usr/bin/openstack-config  --del ${answerfile} general CONFIG_NOVA_NETWORK_HOST",
    require => Exec["set-packstack-kvm-compute-hosts"],
  }
  exec {"set-packstack-quantum-l3-hosts":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_QUANTUM_L3_HOSTS ${network_host}",
    require => Exec["set-packstack-nova-network"],
  }
  exec {"set-packstack-quantum-dhcp-hosts":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_QUANTUM_DHCP_HOSTS ${network_host}",
    require => Exec["set-packstack-quantum-l3-hosts"],
  }
  exec {"set-packstack-quantum-metadata-hosts":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_QUANTUM_METADATA_HOSTS ${network_host}",
    require => Exec["set-packstack-quantum-dhcp-hosts"],
  }
  exec {"set-packstack-quantum-tenant-network-type":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_QUANTUM_OVS_TENANT_NETWORK_TYPE vlan",
    require => Exec["set-packstack-quantum-metadata-hosts"],
  }
  exec {"set-packstack-vlan-range":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_QUANTUM_OVS_VLAN_RANGES physnet1:${vlan_range}",
    require => Exec["set-packstack-quantum-tenant-network-type"],
  }
  exec {"set-packstack-bridge-mappings":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_QUANTUM_OVS_BRIDGE_MAPPINGS physnet1:br-eth1",
    require => Exec["set-packstack-vlan-range"],
  }
  exec {"set-packstack-bridge-interfaces":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_QUANTUM_OVS_BRIDGE_IFACES br-eth1:eth1",
    require => Exec["set-packstack-bridge-mappings"],
  }
}
