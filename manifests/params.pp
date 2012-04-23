# Global configuration variables for the graphite server.
class graphite::params {
  case $operatingsystem {
    /Ubuntu|debian/: {
      $user    = 'graphite'
      $group   = 'graphite'
      $instdir = '/opt/graphite/'
    }
    default: {
      fail("Operatingsystem, $operatingsystem, is not supported by the graphite module")
    }
  }
}
