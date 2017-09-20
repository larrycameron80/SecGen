class kde_minimal::config {
  $secgen_params = secgen_functions::get_parameters($::base64_inputs_file)
  $autologin_user = $secgen_params['autologin_user'][0]

  if $autologin_user != "false" {
    file { "/etc/kde4/kdm/kdmrc":
      ensure => file,
      content => template('kde_minimal/kdmrc.erb'),
    }
  }
}
