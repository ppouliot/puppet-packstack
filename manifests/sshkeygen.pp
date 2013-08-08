class packstack::sshkeygen{

include packstack::params

  exec {"generate-sshkey":
    command => "ssh-keygen -b 1024 -f ${packstack::params::sshkey}",
  }
}
