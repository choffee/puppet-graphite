# Global configuration variables for the graphite server.
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
