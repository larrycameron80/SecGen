class hackerbot::install{
  package { ['sshpass', 'ruby', 'rubygems']:
    ensure => 'installed',
  }

  package { ['cinch', 'nokogiri', 'nori', 'programr']:
    ensure => 'installed',
    provider => 'gem',
  }

  file { '/opt/hackerbot':
    ensure => directory,
    recurse => true,
    source => 'puppet:///modules/hackerbot/opt_hackerbot',
    mode   => '0600',
    owner => 'root',
    group => 'root',
  }

}
