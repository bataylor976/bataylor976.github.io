#== Class: dokuwiki
#
# This module is designed only for the dokuwiki
#
#== Parameters: None
#
#== Actions:
#
#  include dokuwiki
#
#############################
class dokuwiki {

include dokuwiki::httpd
include dokuwiki::mon

   class { 'org:repo' : 
      repo_org        => true,
      proj_htcondor    => false,
      ius_repo_php        => false,
   }
   
   package {'php-ldap':
      ensure		  => 'installed',
   }

   package {'dokuwiki' :
      ensure              => 'latest',
   }

}
