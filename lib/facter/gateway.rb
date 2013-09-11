Facter.add(:gateway) do
  setcode do
  Facter::Util::Resolution.exec( "netstat -nr |grep eth0 |grep UG |awk '{ print $2}'")
  end
end
