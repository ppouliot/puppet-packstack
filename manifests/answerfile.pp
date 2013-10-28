class packstack::answerfile(

  $ssh_pubkey           = $packstack::params::ssh_pubkey,
  $ntp_server_pool      = $packstack::params::ntp_server_pool,
  $kvm_compute_host     = $packstack::kvm_compute_host,
  $network_host         = $packstack::network_host,
  $vlan_range           = $packstack::params::vlan_range,
  $cinder_volume_size   = $packstack::params::cinder_volume_size,
  $answerfile           = $packstack::params::answerfile,
  $openstack_networking = $packstack::params::openstack_networking
  $floating_ip_range    = $packstack::params::floating_ip_range
  $public_if            = $packstack::params::public_if

){

  include packstack::params

#
# --novanetwork-pubif=eth2 --novacompute-privif=eth1


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
  exec {"set-packstack-swift":
    command => "/usr/bin/openstack-config  --del ${answerfile} general CONFIG_SWIFT_INSTALL",
    require => Exec["set-packstack-kvm-compute-hosts"],
  }
  exec {"set-packstack-nova-network":
    command => "/usr/bin/openstack-config  --del ${answerfile} general CONFIG_NOVA_NETWORK_HOST",
    require => Exec["set-packstack-swift"],
  }
  exec {"set-packstack-${openstack_networking}-l3-hosts":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_${openstack_networking}_L3_HOSTS ${network_host}",
    require => Exec["set-packstack-nova-network"],
  }
  exec {"set-packstack-${openstack_networking}-dhcp-hosts":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_${openstack_networking}_DHCP_HOSTS ${network_host}",
    require => Exec["set-packstack-${openstack_networking}-l3-hosts"],
  }
  exec {"set-packstack-${openstack_networking}-metadata-hosts":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_${openstack_networking}_METADATA_HOSTS ${network_host}",
    require => Exec["set-packstack-${openstack_networking}-dhcp-hosts"],
  }
  exec {"set-packstack-${openstack_networking}-tenant-network-type":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_${openstack_networking}_OVS_TENANT_NETWORK_TYPE vlan",
    require => Exec["set-packstack-${openstack_networking}-metadata-hosts"],
  }
  exec {"set-packstack-vlan-range":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_${openstack_networking}_OVS_VLAN_RANGES physnet1:${vlan_range}",
    require => Exec["set-packstack-${openstack_networking}-tenant-network-type"],
  }
  exec {"set-packstack-bridge-mappings":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_${openstack_networking}_OVS_BRIDGE_MAPPINGS physnet1:br-eth1",
    require => Exec["set-packstack-vlan-range"],
  }
  exec {"set-packstack-bridge-interfaces":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_${openstack_networking}_OVS_BRIDGE_IFACES br-eth1:eth1",
    require => Exec["set-packstack-bridge-mappings"],
  }
  exec {"set-packstack-ssl-horizon":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_HORIZION_SSL",
    require => Exec["set-packstack-bridge-interface"],
  }
  exec {"set-packstack-floating-ip-range":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_NOVA_NETWORK_FLOATRANGE ${floating_ip_range}",
    require => Exec["set-packstack-ssl-horizon"],
  }
  exec {"set-packstack-public-if":
    command => "/usr/bin/openstack-config  --set ${answerfile} general CONFIG_NOVA_NETWORK_PUBIF ${public_if}",
    require => Exec["set-packstack-ssl-horizon"],
  }
}
