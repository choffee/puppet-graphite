# A module for installing and configuring a graphite server
class graphite {
  include graphite::params
  include graphite::install
  include graphite::config
}
