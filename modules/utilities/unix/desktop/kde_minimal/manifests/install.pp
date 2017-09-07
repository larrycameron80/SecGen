class kde_minimal::install{
  case $operatingsystem {
    'Debian': {
      package { ['kde-plasma-desktop', 'kate', 'ksnapshot', 'qtcurve']:
        ensure => 'installed',
      }

      # reboot { 'after':
      #   subscribe       => Package['kde-plasma-desktop'],
      # }
      # exec { 'reboot':
      #   cwd => '/sbin/',
      #   command => 'reboot'
      # }

    }
  }
}
