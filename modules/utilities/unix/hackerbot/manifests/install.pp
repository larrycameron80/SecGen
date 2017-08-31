class hackerbot::install{
  $json_inputs = base64('decode', $::base64_inputs)
  $secgen_parameters = parsejson($json_inputs)
  $server_ip = $secgen_parameters['server_ip'][0]
  $hackerbot_configs = $secgen_parameters['hackerbot_configs']

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

  $hackerbot_configs.each |$counter, $config| {
    $num = $counter + 1
    $filename = "bot_$num.xml"

    file { "/opt/hackerbot/config/$filename":
      ensure => present,
      content => $config,
      mode   => '0600',
      owner => 'root',
      group => 'root',
    }
  }

  file { "/opt/hackerbot/hackerbot.rb":
    ensure  => file,
    content  => template('hackerbot/hackerbot.rb.erb'),
    require => File['/opt/hackerbot'],
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
