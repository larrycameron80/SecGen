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

  file { '/etc/systemd/system/hackerbot.service':
    ensure => 'link',
    target => '/opt/hackerbot/hackerbot.service',
  }~>
  exec { 'hackerbot-systemd-reload':
    command     => 'systemctl daemon-reload',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    refreshonly => true,
  }
}
