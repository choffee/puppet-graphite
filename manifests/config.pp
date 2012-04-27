# The generic graphite server config goes here
class graphite::config {
  $user    = $graphite::params::user
  $group   = $graphite::params::group
  $instdir = $graphite::params::instdir
  $wwwuser = $graphite::params::wwwuser

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
  file {"${instdir}/storage":
    owner => $wwwuser,
    group => $wwwuser,
  }

  # Setup the database
  exec {'graphite-install-db':
    environment => ["PYTHONPATH=${instdir}/webapp:${instdir}/whisper"],
    cwd         => $instdir,
    user        => $wwwuser,
    # This prompts for a password and so won't work
    command     => '/usr/bin/python ./webapp/graphite/manage.py syncdb',
    refreshonly => true,
  }


}
