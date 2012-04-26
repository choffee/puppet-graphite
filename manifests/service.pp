#Graphite services
class graphite::service {
  service {'carbon-cache':
    enable => true,
    ensure => running,
  }
}
