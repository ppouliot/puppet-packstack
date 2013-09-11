class packstack::sshkeygen(
$kvm_compute_host = $packstack::kvm_compute_host,
$network_host = $packstack::network_host,
$controller_host = $packstack::controller_host,
){

include packstack::params

  exec {"generate-sshkey":
    command => "/usr/bin/ssh-keygen -b 1024 -f ${packstack::params::ssh_pubkey}",
  }
  file {"${homedir}/RemoteUpload.py":
    ensure => present,
    source => "puppet:///modules/packstack/RemoteUpload.py",
    mode => 777,
  }
  file {"${homedir}/RunSSHCmd.py":
    ensure => present,
    source => "puppet:///modules/packstack/RunSSHCmd.py",
    mode => 777,
  }
  #exec {"remoteupload-sshkey-controller":
   # command => "${homedir}/RemoteUpload.py -c $packstack::controller_host -u root -p redhat -P 22 -r ${homedir}/.ssh/ -f ${homedir}/.ssh/id_rsa.pub",
   # require => [ Exec["generate-sshkey"], File["${homedir}/RemoteUpload.py"] ],
  #}
  exec {"runsshcmd-sshkey-controller":
    command => "${homedir}/RunSSHCmd.py -u root -p redhat -c 'cp ${homedir}/.ssh/id_rsa.pub ${homedir}/.ssh/authorized_keys2' -s $packstack::controller_host -P 22",
    require => [ Exec["generate-sshkey"], File["${homedir}/RunSSHCmd.py"] ],
  }

  exec {"remoteupload-sshkey-compute":
    command => "${homedir}/RemoteUpload.py -c $packstack::kvm_compute_host -u root -p redhat -P 22 -r ${homedir}/.ssh/ -f ${homedir}/.ssh/id_rsa.pub",
    require => [ Exec["generate-sshkey"], File["${homedir}/RemoteUpload.py"] ],
  }
  exec {"runsshcmd-sshkey-compute":
    command => "${homedir}/RunSSHCmd.py -u root -p redhat -c 'mv ${homedir}/.ssh/id_rsa.pub ${homedir}/.ssh/authorized_keys2' -s $packstack::kvm_compute_host -P 22",
    require => [ Exec["generate-sshkey"], File["${homedir}/RunSSHCmd.py"], Exec["remoteupload-sshkey-compute"] ],
  }
  exec {"remoteupload-sshkey-neutron":
    command => "${homedir}/RemoteUpload.py -c $packstack::network_host -u root -p redhat -P 22 -r ${homedir}/.ssh/ -f ${homedir}/.ssh/id_rsa.pub",
    require => [ Exec["generate-sshkey"], File["${homedir}/RemoteUpload.py"] ],
  }
  exec {"runsshcmd-sshkey-neutron":
    command => "${homedir}/RunSSHCmd.py -u root -p redhat -c 'mv ${homedir}/.ssh/id_rsa.pub ${homedir}/.ssh/authorized_keys2' -s $packstack::network_host -P 22",
     require => [ Exec["generate-sshkey"], File["${homedir}/RunSSHCmd.py"], Exec["remoteupload-sshkey-compute"] ],
  }
  Exec ["generate-sshkey"] -> File ["${homedir}/RemoteUpload.py"] -> File ["${homedir}/RunSSHCmd.py"] -> Exec ["runsshcmd-sshkey-controller"] -> Exec ["remoteupload-sshkey-compute"] -> Exec ["runsshcmd-sshkey-compute"] -> Exec ["remoteupload-sshkey-neutron"] -> Exec ["runsshcmd-sshkey-neutron"]
}
