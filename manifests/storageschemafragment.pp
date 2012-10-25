# == Type: graphite::storageschemafragment
#
# This type allows you to add some storage schema fragments
#
# === Parameters
#
# [*content*]
#   String. The content to put in this file
#   It should contain a storage schema fragment for the whispa database
#   eg:

#     [stats]
#     pattern = ^stats.*
#     retentions = 10:2160,60:10080,600:262974
#
# [*ensure*]
#   String. Should the fragment be present or absent
#   <tt>present</tt> or <tt>absent</tt>. If set to <tt>absent</tt>:
#   * The fragment will be removed and the config restarted
#   Defaults to <tt>present</tt>.
#
# [*order*]
#   Integer. Set the order of this fragment. For the most part this is not
#   important
#   Defaults to 40
#
define graphite::storageschemafragment (
  $content,
  $order = 40,
  $ensure = 'present'
) {

  if ! is_integer($order) {
    fail("order should be an integer not \"${order}\".")
  }
  concat::fragment{"storage-schema.conf-${name}":
    target  => "${graphite::instdir}/conf/storage-schemas.conf",
    order   => $order,
    content => $content
  }
}
