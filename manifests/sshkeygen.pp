class packstack::sshkeygen(
$kvm_compute_host = $packstack::kvm_compute_host,
$network_host = $packstack::network_host,
$controller_host = $packstack::controller_host,
){

include packstack::params

  exec {"generate-sshkey":
    command => "/usr/bin/ssh-keygen -b 1024 -f ${packstack::params::ssh_pubkey}",
    creates => "/root/.ssh/id_dsa",
  }
  file {"/usr/local/bin/RemoteUpload.py":
    ensure => present,
    source => "puppet://modules/packstack/RemoteUpload.py",
    mode => 777,
  }
  file {"/usr/local/bin/RunSSHCmd.py":
    ensure => present,
    source => "puppet://modules/packstack/RunSSHCmd.py",
    mode => 777,
  }
  #exec {"remoteupload-sshkey-controller":
   # command => "/usr/local/bin/RemoteUpload.py -c $packstack::controller_host -u root -p redhat -P 22 -r /usr/local/bin/.ssh/ -f /usr/local/bin/.ssh/id_rsa.pub",
   # require => [ Exec["generate-sshkey"], File["/usr/local/bin/RemoteUpload.py"] ],
  #}
  exec {"runsshcmd-sshkey-controller":
    command => "/usr/local/bin/RunSSHCmd.py -u root -p redhat -c 'cp /usr/local/bin/.ssh/id_rsa.pub /usr/local/bin/.ssh/authorized_keys2' -s $packstack::controller_host -P 22",
    require => [ Exec["generate-sshkey"], File["/usr/local/bin/RunSSHCmd.py"] ],
    refreshonly => true,
  }

  exec {"remoteupload-sshkey-compute":
    command => "/usr/local/bin/RemoteUpload.py -c $packstack::kvm_compute_host -u root -p redhat -P 22 -r /usr/local/bin/.ssh/ -f /usr/local/bin/.ssh/id_rsa.pub",
    require => [ Exec["generate-sshkey"], File["/usr/local/bin/RemoteUpload.py"] ],
    refreshonly => true,
  }
  exec {"runsshcmd-sshkey-compute":
    command => "/usr/local/bin/RunSSHCmd.py -u root -p redhat -c 'mv /usr/local/bin/.ssh/id_rsa.pub /usr/local/bin/.ssh/authorized_keys2' -s $packstack::kvm_compute_host -P 22",
    require => [ Exec["generate-sshkey"], File["/usr/local/bin/RunSSHCmd.py"], Exec["remoteupload-sshkey-compute"] ],
    refreshonly => true,
  }
  exec {"remoteupload-sshkey-neutron":
    command => "/usr/local/bin/RemoteUpload.py -c $packstack::network_host -u root -p redhat -P 22 -r /usr/local/bin/.ssh/ -f /usr/local/bin/.ssh/id_rsa.pub",
    require => [ Exec["generate-sshkey"], File["/usr/local/bin/RemoteUpload.py"] ],
    refreshonly => true,
  }
  exec {"runsshcmd-sshkey-neutron":
    command => "/usr/local/bin/RunSSHCmd.py -u root -p redhat -c 'mv /usr/local/bin/.ssh/id_rsa.pub /usr/local/bin/.ssh/authorized_keys2' -s $packstack::network_host -P 22",
    require => [ Exec["generate-sshkey"], File["/usr/local/bin/RunSSHCmd.py"], Exec["remoteupload-sshkey-compute"] ],
    refreshonly => true,
  }
#  Exec ["generate-sshkey"] -> File ["/usr/local/bin/RemoteUpload.py"] -> File ["/usr/local/bin/RunSSHCmd.py"] -> Exec ["runsshcmd-sshkey-controller"] -> Exec ["remoteupload-sshkey-compute"] -> Exec ["runsshcmd-sshkey-compute"] -> Exec ["remoteupload-sshkey-neutron"] -> Exec ["runsshcmd-sshkey-neutron"]
}
