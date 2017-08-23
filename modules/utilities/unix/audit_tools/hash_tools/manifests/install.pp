class hash_tools::install{
  package { ['md5deep']:
    ensure => 'installed',
  }
}
