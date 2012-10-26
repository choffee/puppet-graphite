# == Type: graphite::storageaggregation
#
# This type allows you to add some storage aggregation
#
# === Parameters
#
# [*pattern*]
#   String. The pattern to match
#   It should contain a storage schema fragment for the whispa database
#   eg:
#     "^stats.*"
#
# [*xfilesfactor*]
#   Float. 0 => x => 1. xFilesFactor should be a floating point number between
#   0 and 1, and specifies what fraction of the previous retention level’s
#   slots must have non-null values in order to aggregate to a non-null value.
#   The default is 0.5.
#
# [*aggregationmethod*]
#   String. Should be one of: average, sum, min, max, and last.
#   Specifies the function used to aggregate values for the next retention level.
#   The default is average
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
define graphite::storageaggregation (
  $pattern,
  $xfilesfactor = 0.5,
  $aggregationmethod = 'average',
  $order = 40,
  $ensure = 'present'
) {
  if ! is_integer($order) {
    fail("order should be an integer not \"${order}\".")
  }
  if $xfilesfactor > 1 or $xfilesfactor < 0 {
    fail("xfilesfactor should be between 0 and 1 not \"${xfilesfactor}\"")
  }
  case $aggregationmethod {
    average,sum,min,max,last: {
    }
    default: {
      fail("aggregationmethod should be one of average, sum, min, max or last not \"${aggregationmethod}\"")
    }
  }
  concat::fragment{"storage-aggregation.conf-${name}":
    target  => "${graphite::instdir}/conf/storage-aggregation.conf",
    order   => $order,
    content => template('graphite/storage-aggregation.erb'),
  }
}
