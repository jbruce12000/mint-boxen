# Setup of uboxen

file { 
  '/usr/local/bin/uboxen':
    ensure => link,
    target => '/opt/mint-boxen/uboxen';
  '/etc/puppet/manifests/site.pp':
    ensure => link,
    target => '/opt/mint-boxen/uboxen.pp';
  '/etc/puppet/modules':
    ensure => link,
    target => '/opt/mint-boxen/modules';
  '/var/lib/hiera':
    ensure => link,
    target => '/opt/mint-boxen/data';
}
