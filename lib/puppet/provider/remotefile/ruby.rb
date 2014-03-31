require 'net/http'
require 'net/https'
require 'open-uri'
require 'fileutils'
require 'puppet/util/checksums'
Puppet::Type.type(:remotefile).provide(:ruby) do
  include Puppet::Util::Checksums

  def exists?
    self.debug "#exists? #{resource[:path]} #{resource[:source]}"
    if File.exists? resource[:path]
      return sha1_file(resource[:path]) == resource[:sha1] if resource[:sha1]
      sha1_file(resource[:path]) == sha1(download(resource[:source]))
    else
      nil
    end
  end

  def create
    self.debug "#create #{resource[:path]}"
    FileUtils.rm_f resource[:path]
    self.debug "#create Downloading #{resource[:source]}"
    download_to_file(resource[:source], resource[:path])
  end

  def destroy
    self.debug "#destroy #{resource[:path]}"
    FileUtils.rm_f resource[:path]
  end

  private

  # Download content to a variable in memory.
  # Only use this for very small files, i.e. files containing checksums.
  def download url
    uri = URI.parse(url)
    self.debug "#download Downloading HTTP URI: #{uri}"
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme == 'https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    res = http.start { |http| http.get(uri.path) }
    self.debug "#download HTTP return code is #{res.code}"
    raise "Error retrieving page: #{res.class} #{res.code}" unless res.code == "200"
    res.body
  end

  # Download content directly to a file.
  def download_to_file url, target
    File.open(target, 'w') do |saved_file|
      # the following "open" is provided by open-uri
      open(url) do |read_file|
        saved_file.write(read_file.read)
      end
    end
  end
end
