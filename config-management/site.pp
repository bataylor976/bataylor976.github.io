# Practice puppet lab set up based on Digital Ocean's sample file for puppet manifest
file {'/tmp/example-ip':
  ensure => present,	#resource type file and filename
  mode   => 0644,	#file permissions
  content => "Here is my Public IP Address: ${ipaddress_eth0}.\n", # note the ip address_eth0 fact
}

node 'ns1', 'ns2' {
  file {'/tmp/dns':
    ensure => present,
    mode => 0644,
    content => "Only DNS servers get this file.\n",
  }
}

node default {}

node 'host2' {
  class { 'apache': }	# use apache module
  apache::vhost { 'example.com':	# define vhost resource
    port => 80,
    docroot => '/var/www/html'
  }
}

node 'lamp-1' {
  include lamp
}

node 'host1' {
  include lamp
}

node 'lamp-2' {
  class { 'apache':		# use the 'apache' module'
    default_vhost => false,	# don't use the default vhost
    default_mods => false,	# don't load default mods
    mpm_module => 'prefork',	# use the 'prefork' mpm_module
  }
   include apache::mod::php	#include mod php
   apache::vhost { 'example.com':
    port => '80',		# use port 80
    docroot => '/var/www/html'	# set the docroot to the /var/www/html
  }
  class { 'mysql::server':
    root_password => 'password'
  }
  file { 'info.php':		# file resource name
    path => '/var/www/html/info.php,	# destination path
    ensure => file,
    require => Class['apache'],		# require apache class be used
    source => 'puppet:///modules/apache/info.php', # specify location of file copied
  }
}
