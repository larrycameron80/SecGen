class metasploit_framework::install{
  package { ['postgesql','metasploit-framework']:
    ensure => 'installed',
  }
}
