class hackerbot::service{
  service { 'hackerbot':
    ensure   => running,
    enable   => true,
  }
}
