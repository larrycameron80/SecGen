class hackerbot::install{
  $json_inputs = base64('decode', $::base64_inputs)
  $secgen_parameters = parsejson($json_inputs)
  $server_ip = $secgen_parameters['server_ip'][0]
  $hackerbot_xml_configs = $secgen_parameters['hackerbot_configs']['xml_config']
  $hackerbot_lab_sheets = $secgen_parameters['hackerbot_configs']['html_lab_sheets']

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

  $hackerbot_xml_configs.each |$counter, $config| {
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

  $hackerbot_lab_sheets.each |$counter, $sheet| {
    $num = $counter + 1
    $filename = "lab_x_$num.html"

    file { "/var/www/$filename":
      ensure => present,
      content => $sheet,
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
