#Graphite services
# (c) Copyright John Cooper - Licenced Under GPL Version 3
class graphite::service {
  service {'carbon-cache':
    enable => true,
    ensure => running,
  }
}
