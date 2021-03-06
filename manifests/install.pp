# == Class: packstack::install
class packstack::install {
  include packstack::params
  exec {'run-packstack-install':
    command     => "/usr/bin/packstack --answer-file=${packstack::params::answerfile}",
    cwd         => '/root',
    user        => 'root',
    environment => 'HOME=/root',
    require     => Class['packstack::packages']
  }
}
