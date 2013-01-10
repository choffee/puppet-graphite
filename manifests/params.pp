# == Class: graphite::params
#
# Sets the default values for the parameters of the main module class (see
# <tt>init.pp</tt>) and manages internal module variables.
#
# This class exists to
# 1. Declutter the default value assignment for the parameters of the main
#    module class.
# 2. Manage internally used module variables in a central place.
#
# Therefore, many operating system dependent differences (names, paths, ...)
# are addressed in here.
#
# Have a look at the corresponding <tt>init.pp</tt> manifest file if you need
# more technical information about how the values of this class are used as
# parameter defaults for the main module class.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class is not intended to be used directly.
#
#
# === Links
#
# * {Puppet Docs: Using Parameterized Classes}[http://j.mp/nVpyWY]
#
#
# === Authors
#
# * John Cooper <mailto:john@choffee.co.uk>
#
class graphite::params {

  #### Set default values for the parameters of the main module class, init.pp

  # NOTE: Do not access the following variables if there is no specific reason
  #       to do so. They are defaults for values the user can set. This means:
  #       - Use $graphite::foobar.
  #       - Do not use $graphite::params::foobar.
  #       Otherwise, you will not get the real parameter value (which may
  #       contain user defined data) but only the default one in every case.

  # ensure
  $ensure = 'present'

  # autoupgrade
  $autoupgrade = false

  # service status
  $status = 'enabled'

  # autoload_class
  $autoload_class = false

  # Max updates per second for the whisper database
  $max_updates_per_second = 1000

  # package list
  case $::operatingsystem {
    'Debian', 'Ubuntu': {
      $package    = [ 'python-django',
                      'python-twisted',
                      'python-cairo',
                      'python-pip',
                      'python-django-tagging', ]
      $pippackage = [ 'whisper',
                      'carbon',
                      'graphite-web']
      $user       = 'graphite'
      $group      = 'graphite'
      $instdir    = '/opt/graphite/'
      $storagedir = "${instdir}/storage/"
      $wwwuser    = 'www-data'
    }
    # given OS is unknown (see http://j.mp/x6Mtba for a list of known values)
    default: {
      fail("\"${module_name}\" is not supported on \"${::operatingsystem}\".")
    }
  }

  # debug
  $debug = false



  #### Internal module parameters

  # NOTE: The following variables are internal values the user cannot set as
  #       parameter of the main module class. This means:
  #       - Use $graphite::params::foobar.
  #       - Do not use $graphite::foobar.
  #       This makes clear that you are using an internal module parameter.

  # service parameters (q.v. http://j.mp/q6J073)
  case $::operatingsystem {
    'Debian', 'Ubuntu': {
      $service_name       = 'carbon-cache'
      $service_hasstatus  = false
      $service_hasrestart = false
      $service_pattern    = 'carbon-cache'
    }
    # given OS is unknown (see http://j.mp/x6Mtba for a list of known values)
    default: {
      fail("\"${module_name}\" is not supported on \"${::operatingsystem}\".")
    }
  }


}
