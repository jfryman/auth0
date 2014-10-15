class kibana::install {
  include 'git'

  if $kibana::manage_ruby == true {
    class { 'ruby':
      gems_version => latest,
    }
  }

  vcsrepo { '/opt/kibana':
    ensure   => present,
    provider => git,
    source   => 'git://github.com/rashidkpc/Kibana.git',
    revision => 'v3.1.1',
  }
}
