# Install the required packages for the graphite server
class graphite::install {
  $instdir = $graphite::params::instdir
  $user    = $graphite::params::user

  user {$user:
    ensure => present,
    system => true,
    home   => $instdir,
  }

  package { ['python-django',
             'python-twisted',
             'python-cairo',
             'python-pip',
             'python-django-tagging',
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

  pipinstall {['whisper',
               'carbon',
               'graphite-web']:
  }

  file { "${instdir}/storage/whisper/":
    owner   => $user,
    group   => $user,
    mode    => '0755',
    require => Pipinstall['whisper'],
  }

  # Install carbon-cache init service
  file { '/etc/init.d/carbon-cache':
    content => template('graphite/carbon-cache.init.erb'),
    owner   => root,
    group   => root,
    mode    => '0744',
    require => Pipinstall['carbon'],
  }
}
