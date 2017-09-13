class hackerbot::install{
  $json_inputs = base64('decode', $::base64_inputs)
  $secgen_parameters = parsejson($json_inputs)
  $server_ip = $secgen_parameters['server_ip'][0]

  $hackerbot_xml_configs = []
  $hackerbot_lab_sheets = []

  file { '/opt/hackerbot':
    ensure => directory,
    recurse => true,
    source => 'puppet:///modules/hackerbot/opt_hackerbot',
    mode   => '0600',
    owner => 'root',
    group => 'root',
  }->

    file { "/opt/hackerbot/hackerbot.rb":
      ensure  => file,
      content  => template('hackerbot/hackerbot.rb.erb'),
      require => File['/opt/hackerbot'],
    }

  $secgen_parameters['hackerbot_configs'].each |$counter, $config_pair| {
    $parsed_pair = parsejson($config_pair)
    # $hackerbot_xml_configs = $hackerbot_xml_configs + $parsed_pair['xml_config']
    # $hackerbot_lab_sheets = $hackerbot_lab_sheets + $parsed_pair['html_lab_sheet']
    # notice($hackerbot_xml_configs)
    # alert($hackerbot_lab_sheets)

    # alert($parsed_pair['xml_config'])
    # $num = $counter + 1
    alert("creating bot config")
    $filename = "bot_$counter.xml"

    file { "/opt/hackerbot/config/$filename":
      ensure => present,
      content => $parsed_pair['xml_config'],
      mode   => '0600',
      owner => 'root',
      group => 'root',
    }

    file { '/var/www/labs':
      ensure => 'directory',
    }

    $filename = "lab_r$counter.html"

    file { "/var/www/$filename":
      ensure => present,
      content => $parsed_pair['html_lab_sheet'],
    }

  }



  # # FIXME: not needed if the above happens first, but there seems to be some ordering problems
  # exec { "create-config-dir":
  #   path    => ['/bin', '/usr/bin', '/usr/local/bin', '/sbin', '/usr/sbin'],
  #   command => "mkdir -p /opt/hackerbot/config",
  #   provider => shell,
  # }

  # $hackerbot_xml_configs.each |$counter, $config| {
  #   alert($counter)
  #   $num = $counter + 1
  #   $filename = "bot_$num.xml"
  #
  #   file { "/opt/hackerbot/config/$filename":
  #     ensure => present,
  #     content => $config,
  #     mode   => '0600',
  #     owner => 'root',
  #     group => 'root',
  #   }
  # }
  #
  # $hackerbot_lab_sheets.each |$counter, $sheet| {
  #   $num = $counter + 1
  #   $filename = "lab_x_$num.html"
  #
  #   file { "/var/www/$filename":
  #     ensure => present,
  #     content => $sheet,
  #   }
  # }

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
