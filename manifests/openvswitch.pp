class packstack::openvswitch(
$network_host = $packstack::network_host,
){
    
     exec { "addeth2bridge":
	command => "/usr/bin/ssh -o StrictHostKeychecking=no ${network_host} /usr/bin/ovs-vsctl add-port br-ex eth2"
	}
}

