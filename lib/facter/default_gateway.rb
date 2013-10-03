require 'facter'
Facter.add("default_gateway") do
  setcode do
  Facter::Util::Resolution.exec( "netstat -nr |grep UG |awk '{ print $2}'" )
  end
end
