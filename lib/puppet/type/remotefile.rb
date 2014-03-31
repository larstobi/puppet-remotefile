Puppet::Type.newtype(:remotefile) do
  @doc = "Rmote File resource type for remote sources."
  ensurable

  newparam(:path) do
    desc "The path to the file to manage. Must be fully qualified."
    isnamevar
  end


  newparam(:source) do
    desc "Remote source URL."

    validate do |value|
      unless value.match %r|^https?://|
        self.fail "(#{value}) remote source URL must start with http:// or https://"
      end
    end
  end

  # TODO: rename it checksum and make it a property.
  newparam(:sha1) do
    desc "The SHA1 checksum of the file."
    defaultto :nil
  end
end
