Remotefile
==========

This is a Puppet resource type for a local file with a remote source. Currently
supported remote transport protocols include HTTP and HTTPS.

Usage
-----

```
remotefile {
  '/var/tmp/README.txt':
    ensure => present,
    source => 'https://yum.puppetlabs.com/README.txt',
    sha1   => '52dd49b85dd79f8303d0af23a0dd655dd208560b';
}
```

The sha1 parameter is optional, however recommended. If not specified, the
provider will download the file every time Puppet runs to check the SHA1 sum.

License
-------

Apache License, Version 2.0

Contact
-------

Lars Tobias Skjong-Borsting <larstobi@conduct.no>

Support
-------

Please log tickets and issues at the [project site](https://github.com/larstobi/puppet-remotefile/issues).
