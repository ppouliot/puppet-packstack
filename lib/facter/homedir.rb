require 'facter'
Facter.add("homedir") do
  setcode do
  Facter::Util::Resolution.exec( "echo $HOME")
  end
end

