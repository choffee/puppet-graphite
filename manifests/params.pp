# Global configuration variables for the graphite server.
# (c) Copyright John Cooper - Licenced Under GPL Version 3
class graphite::params {
  case $operatingsystem {
    /Ubuntu|debian/: {
      $user    = 'graphite'
      $group   = 'graphite'
      $instdir = '/opt/graphite/'
      $wwwuser = 'www-data'
    }
    default: {
      fail("Operatingsystem, $operatingsystem, is not supported by the graphite module")
    }
  }
}
