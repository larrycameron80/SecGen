class hackerbot::install{
  $json_inputs = base64('decode', $::base64_inputs)
  $secgen_parameters = parsejson($json_inputs)
  $server_ip = $secgen_parameters['server_ip'][0]
  $port = $secgen_parameters['port'][0]

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

  file { '/var/www/labs':
    ensure => directory,
    recurse => true,
    source => 'puppet:///modules/hackerbot/www',
    mode   => '0600',
    owner => 'root',
    group => 'root',
  }->

  class { '::apache':
    default_vhost => false,
    # overwrite_ports => false,
  }
  apache::vhost { 'vhost.labs.com':
    port    => $port,
    docroot => '/var/www/labs',
  }->

  file { "/opt/hackerbot/hackerbot.rb":
    ensure  => file,
    content  => template('hackerbot/hackerbot.rb.erb'),
    require => File['/opt/hackerbot'],
  }

  $secgen_parameters['hackerbot_configs'].each |$counter, $config_pair| {
    $parsed_pair = parsejson($config_pair)

    alert("creating bot config")
    $xmlfilename = "bot_$counter.xml"

    file { "/opt/hackerbot/config/$xmlfilename":
      ensure => present,
      content => $parsed_pair['xml_config'],
      mode   => '0600',
      owner => 'root',
      group => 'root',
    }

    $htmlfilename = "lab_r$counter.html"

    file { "/var/www/html/$htmlfilename":
      ensure => present,
      content => $parsed_pair['html_lab_sheet'],
    }

  }

  package { ['nori', 'cinch', 'programr']:
    ensure   => 'installed',
    provider => 'gem',
  } ->

  file { '/etc/systemd/system/hackerbot.service':
    ensure => 'link',
    target => '/opt/hackerbot/hackerbot.service',
  }~>
  # reload services (networking needs to be reloaded on the kali virtualbox vm)
  exec { 'hackerbot-systemd-reload':
    command     => 'systemctl daemon-reload; service networking restart; service hackerbot restart',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    refreshonly => true,
  }

}
