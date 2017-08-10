#== Class: dokuwiki::httpd
#
# This module installs and configures webserver related configuration for dokuwiki.
#
#== Parameters: None
#
#== Actions:
#
# include dokuwiki::httpd
#
#############################
class dokuwiki::httpd {

#include dokuwiki::wikiconf
   $usernames = hiera('usernames')
   $user = "user ${usernames}"

   class { 'apache':
      default_mods        => false,
      default_confd_files => false,
      mpm_module          => 'prefork',
      purge_configs       => true,
      server_signature    => 'Off',
      service_ensure      => 'running',
      default_vhost       => false,
      manage_user         => false,
      manage_group        => false,
      user                => 'apache',
      group               => 'apache',
   }

   class { '::apache::mod::deflate':
      types => [ 'text/html text/plain text/xml', 'text/css', 'application/x-javascript application/javascript application/ecmascript', 'application/rss+xml', 'application/json', 'application/vnd.geo+json' ],
         notes => {
            'Input'  => 'instream',
            'Output' => 'outstrem',
            'Ratio'  => 'ratio',
         },
    }

   class { '::apache::mod::ssl':
       ssl_compression         => false,
       ssl_cryptodevice        => 'builtin',
       ssl_options             => [ 'StdEnvVars' ],
       ssl_openssl_conf_cmd    => undef,
       ssl_honorcipherorder    => 'On',
       ssl_cipher              => 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!3DES:!MD5:!PSK',
       ssl_pass_phrase_dialog  => 'builtin',
       ssl_random_seed_bytes   => '1024',
       ssl_sessioncachetimeout => '300',
       ssl_protocol            => [ 'all', '-TLSv1', '-SSLv3', '-SSLv2'],
    }

   class { 'apache::mod::alias':
       icons_options => 'None',
    }

   apache::mod { 'actions' : }
   apache::mod { 'cgi' :}
   apache::mod { 'headers' :}
   apache::mod { 'include' :}
   apache::mod { 'mime_magic' :}
   apache::mod { 'auth_basic' :}
   apache::mod { 'authn_core' :}
   apache::mod { 'setenvif' :} 
   apache::mod { 'authz_user' :} 
   apache::mod { 'dir' :}
   apache::mod { 'suphp' :}
   apache::mod { 'php5' :}
   apache::mod { 'ldap' :}
   apache::mod { 'authnz_ldap' :}

   file { '/etc/httpd/conf/mime.types':
      ensure            => present,
      owner             => 'root',
      group             => 'root',
      mode              => '0644',
   }

   file { '/usr/share/dokuwiki':
      ensure            => 'directory',
      recurse           => true,
      owner             => 'apache',
      group             => 'apache',
      mode              => '0644',
   }

   file { '/usr/share/dokuwiki/doku.php':
      ensure 		=> present,
      owner		=> 'apache',
      group 		=> 'apache',
      mode 		=> '0755',
   }
  
   file { '/usr/share/dokuwiki/index.php':
      ensure 		=> present,
      owner		=> 'apache',
      group             => 'apache',
      mode		=> '0755',
   }

   file { '/usr/share/dokuwiki/feed.php':
      ensure		=> present,
      owner             => 'apache',
      group             => 'apache',
      mode              => '0755',
   }

   file { '/etc/httpd/modules/mod_php5.so':
      ensure => link,
      target => '/etc/httpd/modules/libphp5.so',
   }

   
   apache::namevirtualhost { '80' :}
   apache::namevirtualhost { '443' :}

   apache::vhost { "${::fqdn}_ssl" :
      servername        => "${::fqdn}",
      docroot           => "/usr/share/dokuwiki",
      manage_docroot    => false,
      priority          => '0',
      port              => '443',
      access_log_file   => "${::hostname}-access.log",
      default_vhost     => true,
      directoryindex    => 'index.html index.shtml index.php doku.php',
      ensure            => present,
      error_log_file    => "${::hostname}-error.log",
      log_level         => 'warn',
      ssl               => true,
      ssl_ca            => '/etc/pki/tls/certs/ornl.gov.int.ca',
      ssl_certs_dir     => '/etc/pki/tls/certs',
      ssl_cert          => '/etc/pki/tls/certs/ornl.gov.crt',
      ssl_key           => '/etc/pki/tls/private/ornl.gov.key',
      directories       => [
         {
          path          => "/usr/share/dokuwiki",
          options       => ['Indexes', 'FollowSymlinks'],
          addhandlers => [{ handler => 'php5-script', extensions => ['.php']}],
          auth_require  => 'valid-user',
          directoryindex => 'index.php doku.php',
          custom_fragment => 'AddType application/x-httpd-php .php'
         },
	 {
          path                            => '/',
          provider              	  => 'location',
	  auth_type			  => 'Basic',
          auth_basic_provider 		  => 'ldap',
          auth_name 			  => "DokuWiki: Authentication Required",
          auth_ldap_url			  => ')',
          auth_ldap_group_attribute 	  => 'member',
	  auth_ldap_group_attribute_is_dn => 'off',
          require			  => "${user}",
	 },		
         {
	  path          => "/usr/share/dokuwiki/data",
	  auth_require  => 'all denied', 	
         },
	 {
	  path          => "/usr/share/dokuwiki/conf",
          auth_require  => 'all denied',
         },
	 {
	  path		=> "/usr/share/dokuwiki/bin",
	  auth_require  => 'all denied',
         },
	 { 
	  path          => "/usr/share/dokuwiki/inc",
          auth_require  => 'all denied',
         },
      ],
   }

   apache::vhost { "${::fqdn}" :
      servername        => "${::fqdn}",
      docroot           => "/usr/share/dokuwiki",
      manage_docroot    => false,
      priority          => '10',
      port              => '80',
      access_log_file   => "${::hostname}-access.log",
      default_vhost     => true,
      directoryindex    => 'index.html index.shtml index.php doku.php',
      ensure            => present,
      error_log_file    => "${::hostname}-error.log",
      log_level         => 'warn',
      directories       => [
         {
          path          => "/usr/share/dokuwiki",
          options       => ['Indexes', 'FollowSymlinks'],
          addhandlers => [{ handler => 'php5-script', extensions => ['.php']}],
          auth_require  => 'valid-user',
          directoryindex => 'index.php doku.php',
          custom_fragment => 'AddType application/x-httpd-php .php'
         },
         {
          path                            => '/',
          provider                        => 'location',
          auth_type                       => 'Basic',
          auth_basic_provider             => 'ldap',
          auth_name                       => "DokuWiki: Authentication Required",
          auth_ldap_url                   => 'ldaps://ldapserver.company.com/ou=****,dc=****,dc=***?uid?sub?(objectClass=*)',
          auth_ldap_group_attribute       => 'member',
          auth_ldap_group_attribute_is_dn => 'off',
          require                         => "${user}",
         },
         {
          path          => "/usr/share/dokuwiki/data",
          auth_require  => 'all denied',
         },
         {
          path          => "/usr/share/dokuwiki/conf",
          auth_require  => 'all denied',
         },
         {
          path          => "/usr/share/dokuwiki/bin",
          auth_require  => 'all denied',
         },
         {
          path          => "/usr/share/dokuwiki/inc",
          auth_require  => 'all denied',
         },
      ],
      rewrites          => [
          {
           rewrite_cond  => ['%{HTTPS} off'],
           rewrite_rule  => ['.* https://%{HTTP_HOST}%{REQUEST_URI} [L,R=302]'],
          }
       ],
   }
}
