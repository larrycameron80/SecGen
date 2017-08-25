class hackerbot::install{
  package { ['sshpass', 'ruby', 'rubygems']:
    ensure => 'installed',
  }

  package { ['cinch', 'nokogiri', 'nori', 'programr']:
    ensure => 'installed',
    provider => 'gem',
  }

  file { 'hackerbot files':
    path => '/opt/hackerbot/',
    ensure => recursive,
    source => 'puppet:///modules/hackerbot/opt_hackerbot/',
  }

}
