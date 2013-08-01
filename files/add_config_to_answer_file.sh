ANSWERS_FILE=packstack_answers.conf
NETWORK_HOST=10.10.10.2
KVM_COMPUTE_HOST=10.10.10.3
openstack-config --set $ANSWERS_FILE general CONFIG_SSH_KEY /root/.ssh/id_rsa.pub
openstack-config --set $ANSWERS_FILE general CONFIG_NTP_SERVERS 0.pool.ntp.org,1.pool.ntp.org,2.pool.ntp.org,3.pool.ntp.org
openstack-config --set $ANSWERS_FILE general CONFIG_CINDER_VOLUMES_SIZE 20G
openstack-config --set $ANSWERS_FILE general CONFIG_NOVA_COMPUTE_HOSTS $KVM_COMPUTE_HOST
openstack-config --del $ANSWERS_FILE general CONFIG_NOVA_NETWORK_HOST
openstack-config --set $ANSWERS_FILE general CONFIG_QUANTUM_L3_HOSTS $NETWORK_HOST
openstack-config --set $ANSWERS_FILE general CONFIG_QUANTUM_DHCP_HOSTS $NETWORK_HOST
openstack-config --set $ANSWERS_FILE general CONFIG_QUANTUM_METADATA_HOSTS $NETWORK_HOST
openstack-config --set $ANSWERS_FILE general CONFIG_QUANTUM_OVS_TENANT_NETWORK_TYPE vlan
openstack-config --set $ANSWERS_FILE general CONFIG_QUANTUM_OVS_VLAN_RANGES physnet1:1000:2000
openstack-config --set $ANSWERS_FILE general CONFIG_QUANTUM_OVS_BRIDGE_MAPPINGS physnet1:br-eth1
openstack-config --set $ANSWERS_FILE general CONFIG_QUANTUM_OVS_BRIDGE_IFACES br-eth1:eth1
