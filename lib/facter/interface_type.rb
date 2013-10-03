require 'facter'
Facter.add("interface_type") do
  setcode do
    Facter::Util::Resolution.exec("ip a | grep ^[0-9] |awk '{ print $2}'| sed -e '/lo/d' | sed -e 's/[0-9]://g'| sed -e '$!N; /^\\(.*\\)\\n\\1$/!P; D'")
  end
end
