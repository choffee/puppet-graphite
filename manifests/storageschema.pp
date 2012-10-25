# == Type: graphite::storageschema
#
# This type allows you to add some storage schema
#
# === Parameters
#
# [*pattern*]
#   String. The pattern to match
#   It should contain a storage schema fragment for the whispa database
#   eg:
#     "^stats.*"
#
# [*retentions*]
#   String. The retention pattern.
#   eg:
#      10:2160,60:10080,600:262974
#
# [*ensure*]
#   String. Should the setting be present or absent
#   <tt>present</tt> or <tt>absent</tt>. If set to <tt>absent</tt>:
#   * The setting will be removed and the config restarted
#   Defaults to <tt>present</tt>.
#
# [*order*]
#   Integer. Set the order of this setting. For the most part this is not
#   important
#   Defaults to 40
#
define graphite::storageschema ( $content, $order = 40, $ensure = 'present') {
  if ! is_integer($order) {
    fail("order should be an integer not \"${order}\".")
  }
  concat::fragment{"storage-schema.conf-${name}":
    target  => "${graphite::instdir}/conf/storage-schemas.conf",
    order   => $order,
    content => template('graphite/storage-schema.erb'),
  }
}
