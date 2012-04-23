# Install the required packages for the graphite server
class graphite::install {
  package { ['python-django',
             'python-twisted',
             'python-cairo',
             'python-pip',
             ]:
    ensure => installed,
  }

  # Wrapper around installing pip modules
  # Use with the pip module name to install
  # and testmodule is what is use to test if it is already
  # installed
  define pipinstall () {
    exec {$title:
      command => "/usr/bin/pip install ${title}",
      unless  => "/usr/bin/pip freeze | grep  ${title}",
      require => Package['python-pip'],
    }
  }

  pipinstall {'carbon':
  }
  pipinstall {'graphite-web':
  }

  file {'/etc/init.d/graphite':
    source => 'puppet:///modules/graphite/graphite.init',
    owner  => root,
    group  => root,
    mode   => '0544',
  }

  service {'graphite':
    ensure => enabled,
  }
}
