# == Class: graphite::config
#
# This class exists to coordinate all configuration related actions,
# functionality and logical units in a central place.
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
#   class { 'graphite::config': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * John Cooper <mailto:john@choffee.co.uk>
#
class graphite::config {
  $user    = $graphite::user
  $group   = $graphite::group
  $instdir = $graphite::instdir
  $wwwuser = $graphite::wwwuser

  file {"${instdir}/conf/aggregation-rules.conf":
    content => template('graphite/aggregation-rules.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
  }
  file {"${instdir}/conf/carbon.amqp.conf":
    content => template('graphite/carbon.amqp.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
  }
  file {"${instdir}/conf/carbon.conf":
    content => template('graphite/carbon.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
  }
  file {"${instdir}/conf/dashboard.conf":
    content => template('graphite/dashboard.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
  }
  file {"${instdir}/conf/graphite.wsgi":
    content => template('graphite/graphite.wsgi.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
  }
  file {"${instdir}/conf/graphTemplates.conf":
    content => template('graphite/graphTemplates.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
  }
  file {"${instdir}/conf/relay-rules.conf":
    content => template('graphite/relay-rules.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
  }
  file {"${instdir}/conf/rewrite-rules.conf":
    content => template('graphite/rewrite-rules.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
  }
  file {"${instdir}/conf/storage-schemas.conf":
    content => template('graphite/storage-schemas.conf.erb'),
    owner   => root,
    group   => root,
    mode    => '0444',
  }

  # Setup the database XXX TODO This is only requred for new installs,
  # can we check for the presense of a db here already?
  exec {'graphite-install-db':
    environment => ["PYTHONPATH=${instdir}/webapp:${instdir}/whisper"],
    cwd         => $instdir,
    user        => $wwwuser,
    # This prompts for a password and so won't work
    command => '/usr/bin/python ./webapp/graphite/manage.py syncdb',
    unless  => "/usr/bin/test -f ${instdir}/storage/graphite.db",
  }


  #### Configuration

  # nothing right now

  # Helpful snippet(s):
  #
  # Config file. See 'file' doc at http://j.mp/wKju0C for information.
  # file { 'graphite_config':
  #   ensure  => 'present',
  #   path    => '/etc/graphite/graphite.conf',
  #   mode    => '0644',
  #   owner   => 'root',
  #   group   => 'root',
  #   # If you specify multiple file sources for a file, then the first source
  #   # that exists will be used.
  #   source  => [
  #     "puppet:///modules/graphite/config.cfg-$::fqdn",
  #     "puppet:///modules/graphite/config.cfg-$::hostname",
  #     'puppet:///modules/graphite/config.cfg'
  #   ],
  #   content => template('graphite/config.erb'),
  #   notify  => Service['graphite'],
  # }

}
