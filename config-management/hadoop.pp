class remove-pig {
  package { 'pig':
    ensure => 'purged',
}
}

node 'XXXXXX00' {
  class { '::cloudera':
    cm_server_host => 'XXXXXX00',
    install_cmserver => true,
}  
  class { 'remove-pig': }
}

node 'XXXXXX01' {
  class { '::cloudera':
    cm_server_host => 'XXXXXX00',
}
}

node 'XXXXXX02' {
  class { '::cloudera':
    cm_server_host => 'XXXXXX00',
}
}

node 'XXXXXX03' {
  class { '::cloudera':
    cm_server_host => 'XXXXXX00',
}
}

node 'XXXXXX04' {
  class { '::cloudera':
    cm_server_host => 'XXXXXX00',
}
}

node 'XXXXXX05' {
  class { '::cloudera':
    cm_server_host => 'XXXXXX00',
}
}

node 'XXXXXX06' {
  class { '::cloudera':
    cm_server_host => 'XXXXXX00',
}
}

node 'XXXXXX07' {
  class { '::cloudera':
    cm_server_host => 'XXXXXX00'
}
}

node 'XXXXXX08' {
  class { '::cloudera':
    cm_server_host => 'XXXXXX00',
}
}
