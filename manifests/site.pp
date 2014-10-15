# totally cheating. ;)
node default {

  # Install MongoDB
  class {'::mongodb::globals':
    manage_package_repo => true,
    before              => Class['::mongodb::server'],
  }

  class { '::mongodb::server':
    bind_ip => [
      $::ipaddress,
      '127.0.0.1',
    ],
    verbose => true,
    profile => '2',
  }

  ::mongodb::db { 'slowdb':
    user     => 'turtle',
    password => 'alwaysbeatsthehare',
  }

  # Install Logstash
  class { '::logstash':
    java_install    => true,
    manage_repo     => true,
    repo_version    => '1.4',
  }

  ::logstash::configfile { 'base_config':
    content => template('authzero/logstash/base_config.erb'),
  }
  ::logstash::patternfile { 'mongodb_slowqueries':
    source  => 'puppet:///modules/authzero/logstash/mongodb_slowqueries',
  }  

  # Install kibana
  class { '::elasticsearch': 
    manage_repo  => true,
    repo_version => '1.3',
  }
  ::elasticsearch::instance { $::fqdn: }
    
  class { '::kibana':
    require => Class['::elasticsearch'],
  }

  class { 'nginx': }
  nginx::resource::vhost { 'auth0.fryman.io':
    www_root => '/opt/kibana/src',
  }
}
