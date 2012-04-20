# Global configuration variables for the graphite server.
class graphite::params {
  case $operatingsystem {
    /Ubuntu|debian/: {
      $foo=bar

    }
    default: {
      fail("Operatingsystem, $operatingsystem, is not supported by the graphite module")
    }
  }
}
