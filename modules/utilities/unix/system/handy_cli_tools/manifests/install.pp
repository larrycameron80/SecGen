class handy_cli_tools::install{
  package { ['vim.tiny','rsync']:
    ensure => 'installed',
  }
}
