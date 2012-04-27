# A module for installing and configuring a graphite server
class graphite {
  include graphite::params  
  include graphite::install 
  include graphite::config
  include graphite::service

  Class["graphite::service"] ->
  Class["graphite::config"] ->
  Class["graphite::install"] ->
  Class["graphite::params"]
}
