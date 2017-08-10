#== Class: dokuwiki::mon
#
# This module install nrpe and setup the check command.
#
#== Parameters: None
#
#== Actions: 
#
#
#
#############################
class dokuwiki::mon {

    package {'sysstat' :
      ensure              => 'latest',
    }

    class { 'nrpe':
       version  => 'latest',
    }

    nrpe::config { 'nrpe.cfg':
	allowed_hosts => '127.0.0.1,160.91.19.12',
    }->

    user { 'nagios':
       ensure             => 'present',
       password           => 'NOLOGIN',
    }

    nrpe::command {
        'check_users': cmd => "check_users -w 20 -c 25";
	'check_load':  cmd => "check_load -w 20,25,30 -c 30,40,45";
	'check_disks': cmd => "check_disk -w 10% -c 5% -A -i /boot -i /run -i /dev -i /sys/fs/cgroup /";
	'check_zombie_procs': cmd => "check_procs -w 5 -c 10 -s Z";
	'check_total_procs':  cmd => "check_procs -w 300 -c 400";
        'check_ntp': cmd => "check_ntp_time -H timeserver.company.com -w 0.05 -c .5";
        'check_mail_queue': cmd => "check_mailq -w 5 -c 10";
    }

    firewall { '5666 allow nrpe access':
      dport  => [5666],
      proto  => tcp,
      action => accept,
   }
}
