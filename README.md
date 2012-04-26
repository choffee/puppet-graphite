A puppet module to install graphite on a server.
================================================

Currently it has only been tested on ubuntu lucid.

Just clone the module into your directory then add the following to your host to get started.

  include graphite
  graphite::apache{ "graphite.example.com": }


