# == Class: graphite::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'graphite::package': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * John Cooper <mailto:john@choffee.co.uk>
#
class graphite::package {

  #### Package management

  # set params: in operation
  if $graphite::ensure == 'present' {

    # Install all managed packages if not present. Present packages are getting
    # upgraded by using 'latest' if there is a newer version than the present
    # one and the corresponding variable evaluates to true. The exact 'latest'
    # behavior is provider dependent. Q.v.:
    # - Puppet type reference (package, "upgradeable"): http://j.mp/xbxmNP
    # - Puppet's package provider source code: http://j.mp/wtVCaL
    $package_ensure = $graphite::autoupgrade ? {
      true  => 'latest',
      false => 'present',
    }

  # set params: removal
  } else {

    # Remove/purge all managed packages and their configuration files. The
    # exact 'purged' behavior is provider dependent. Q.v.:
    # - Puppet type reference (package, "purgeable"): http://j.mp/xbxmNP
    # - Puppet's package provider source code: http://j.mp/wtVCaL
    $package_ensure = 'purged'

  }

  # action
  package { $graphite::package:
    ensure => $package_ensure,
  }

  # Make sure augeas is installed
  package { 'augeas-tools':
    ensure => installed,
  }

  # Create the graphite user
  # Remove this for now and let owner control this
  #user {$graphite::user:
  #  ensure => present,
  #  home   => "${graphite::instdir}/storage",
  #}
  # Wrapper around installing pip modules
  # Use with the pip module name to install
  # and testmodule is what is use to test if it is already
  # installed
  define pipinstall ($ensure) {
    if $graphite::ensure == 'present' {
      exec {$title:
        command => "/usr/bin/pip install ${title}",
        unless  => "/usr/bin/pip freeze | grep  ${title}",
        require => Package['python-pip'],
      }
    } else {
      exec {$title:
        command => "/usr/bin/pip uninstall ${title}",
        onlyif  => "/usr/bin/pip freeze | grep  ${title}",
        require => Package['python-pip'],
      }
    }

  }

  pipinstall {$graphite::pippackage:
    ensure => $package_ensure,
  }

  file {"${graphite::storagedir}":
    owner => $graphite::wwwuser,
    group => $graphite::wwwuser,
    mode  => '0775',
  }
  file { "${graphite::storagedir}/whisper/":
    owner   => $graphite::user,
    group   => $graphite::user,
    mode    => '0755',
    require => Pipinstall['whisper'],
  }

  # Install carbon-cache init service
  file { "/etc/init.d/${graphite::params::service_name}":
    content => template("graphite/${graphite::params::service_name}.init.erb"),
    owner   => root,
    group   => root,
    mode    => '0744',
    require => Pipinstall['carbon'],
  }

}
