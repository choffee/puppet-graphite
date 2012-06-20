# == Class: graphite
#
# This class is able to install or remove graphite on a node.
#
# [Add description - What does this module do on a node?] FIXME/TODO
#
#
# === Parameters
#
# [*ensure*]
#   String. Controls if the resources managed by this module shall be
#   <tt>present</tt> or <tt>absent</tt>. If set to <tt>absent</tt>:
#   * The managed software packages are being uninstalled.
#   * Any traces of the packages will be purged as good as possible. This may
#     include existing configuration files. The exact behavior is provider
#     dependent. Q.v.:
#     * Puppet type reference: {package, "purgeable"}[http://j.mp/xbxmNP]
#     * {Puppet's package provider source code}[http://j.mp/wtVCaL]
#   * System modifications (if any) will be reverted as good as possible
#     (e.g. removal of created users, services, changed log settings, ...).
#   * This is thus destructive and should be used with care.
#   Defaults to <tt>present</tt>.
#
# [*autoupgrade*]
#   Boolean. If set to <tt>true</tt>, any managed package gets upgraded
#   on each Puppet run when the package provider is able to find a newer
#   version than the present one. The exact behavior is provider dependent.
#   Q.v.:
#   * Puppet type reference: {package, "upgradeable"}[http://j.mp/xbxmNP]
#   * {Puppet's package provider source code}[http://j.mp/wtVCaL]
#   Defaults to <tt>false</tt>.
#
# [*status*]
#   String to define the status of the service. Possible values:
#   * <tt>enabled</tt>: Service is running and will be started at boot time.
#   * <tt>disabled</tt>: Service is stopped and will not be started at boot
#     time.
#   * <tt>running</tt>: Service is running but will not be started at boot time.
#     You can use this to start a service on the first Puppet run instead of
#     the system startup.
#   * <tt>unmanaged</tt>: Service will not be started at boot time and the
#     module does not care whether a service is running or not. You can
#     use this e.g. if a cluster management software is used to decide when to
#     start services plus assuring they are running on the desired node.
#   Defaults to <tt>enabled</tt>. The singular form ("service") is used for the
#   sake of convenience. Of course, the defined status affects all services if
#   more than one is managed by this module (see <tt>service.pp</tt> to check
#   if this is the case).
#
# [*autoload_class*]
#   String or <tt>false</tt>. Name of a custom class to manage module
#   customization beyond the capabilities of the available module parameters
#   (e.g. by using class inheritance to overwrite resources). If defined, this
#   module will automatically execute <tt>class { $autoload_class: }</tt>.
#   Excessive usage of this feature is not recommended in order to keep node
#   definitions and class dependencies maintainable. Defaults to <tt>false</tt>.
#
# [*package*]
#   The default value to define which packages are managed by this module gets
#   set in graphite::params. This parameter is able to overwrite the default.
#   Just specify your own package list as a {Puppet array}[http://j.mp/wzu7L3].
#   However, usage of this feature is <b>not recommended</b> in order to keep
#   the node definitions maintainable. It exists for <b>exceptional cases
#   only</b>.
#
# [*pippackage*]
#   The default value to define which pip packages are managed by this module
#   gets set in graphite::params. This parameter is able to overwrite the
#   default. Just specify your own package list as a
#   {Puppet array}[http://j.mp/wzu7L3].
#   However, usage of this feature is <b>not recommended</b> in order to keep
#   the node definitions maintainable. It exists for <b>exceptional cases
#   only</b>.
#
# [*user*]
#   The default user to run graphite as which is defined in the params file
#   but can be overridden here.
#
# [*group*]
#   The default group to run graphite as which is defined in the params file
#   but can be overridden here.
#
# [*instdir*]
#   The base of the graphite install. This is defined in the params file but
#   can also be overridden here.
#
# [*wwwuser*]
#   The user that the graphite web app will be running as. This is set in the
#   params file but you can override it here. If you are using the nginx class
#   defined here then this will set the user that that service runs as but you
#   can also define your own web server and user and this will set up
#   permissions correctly for that.
#
# [*storagedir*]
#   Override where whisper and graphite store their data
#
# [*debug*]
#   Boolean switch to control the debugging functionality of this module. If set
#   to <tt>true</tt>:
#   * The main module class dumps all variables in its scope into the file
#     <tt>$settings::vardir/debug_[module_name]_vardump</tt>. This will be done
#     on every Puppet run. The file is located on the node
#     (<tt>{$settings::vardir}[http://j.mp/w1g0Bl]</tt> is
#     <tt>/var/lib/puppet</tt> by default).
#   * The variable dump file gives you the chance to spot if some variable is
#     not set as you want. Please note that variable names matching the pattern
#     <tt>/(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/</tt>
#     are excluded for security reasons.
#   If set to <tt>false</tt>:
#   * All debugging features are disabled.
#   * All possibly existing debug files this module created are being
#     removed/cleaned up (e.g. <tt>debug_[module_name]_vardump</tt>).
#   Defaults to <tt>false</tt>.
#
# The default values for the parameters are set in graphite::params. Have
# a look at the corresponding <tt>params.pp</tt> manifest file if you need more
# technical information about them.
#
#
# === Examples
#
# * Installation:
#     class { 'graphite': }
#
# * Removal/decommissioning:
#     class { 'graphite':
#       ensure => 'absent',
#     }
#
# * Install everything but disable service(s) afterwards
#     class { 'graphite':
#       status => 'disabled',
#     }
#
# * Installation with alternative package list:
#     class { 'graphite':
#       package => [ "foo", "bar-1.2.3" ],
#     }
#
# * Run installation with enabled debugging:
#     class { 'graphite':
#       debug => true,
#     }
#
#
# === Authors
#
# * John Cooper <mailto:john@choffee.co.uk>
#
class graphite(
  $ensure         = $graphite::params::ensure,
  $autoupgrade    = $graphite::params::autoupgrade,
  $status         = $graphite::params::status,
  $autoload_class = $graphite::params::autoload_class,
  $package        = $graphite::params::package,
  $pippackage     = $graphite::params::pippackage,
  $debug          = $graphite::params::debug,
  $user           = $graphite::params::user,
  $group          = $graphite::params::group,
  $instdir        = $graphite::params::instdir,
  $storagedir     = $graphite::params::storagedir,
  $wwwuser        = $graphite::params::wwwuser
) inherits graphite::params {

  #### Validate parameters

  # ensure
  if ! ($ensure in [ 'present', 'absent' ]) {
    fail("\"${ensure}\" is not a valid ensure value.")
  }

  # autoupgrade
  validate_bool($autoupgrade)

  # service status
  if ! ($status in [ 'enabled', 'disabled', 'running', 'unmanaged' ]) {
    fail("\"${status}\" is not a valid status value.")
  }

  # autoload_class
  if $autoload_class != false {
    if !is_string($autoload_class) or empty($autoload_class) {
      fail('"autoload_class" must be a valid class name or false.')
    }
    if $autoload_class !~ /^[a-z](?:[a-z0-9_]*(?:\:\:)*[a-z0-9_]*){1,}[a-z0-9_]{1}$/ { # Cf. naming rules: http://j.mp/xuM3Rr and http://j.mp/wZ8quk
      warning("\"${autoload_class}\" violates class naming restrictions.")
    }
  }

  # package list
  if !is_array($package) or empty($package) {
    fail('"package" must be an array of package names, containing at least one element.')
  }

  # debug
  validate_bool($debug)



  #### Manage module actions


  # package(s)
  class { 'graphite::package': }

  # configuration
  class { 'graphite::config': }   

  # service(s)
  class { 'graphite::service': }

  # automatically load/include custom class if needed
  if $autoload_class != false {
    class { $autoload_class: }
  }



  #### Manage basic relationships    # FIXME/TODO: Remove the whole relationships block if not needed

  if $ensure == 'present' {
    # we need the software before configuring it
    Class['graphite::package'] -> Class['graphite::config'] 

    # we need the software and a working configuration before running a service
    Class['graphite::config']  -> Class['graphite::service']  

  } else {

    # make sure all services are getting stopped before software removal
    Class['graphite::service'] -> Class['graphite::package']
  }



  #### Debugging

  # dump variable names and values (idea from A. Franceschi, http://j.mp/wBJRjo)
  $debug_vardump_ensure = $debug ? {
    true  => 'present',
    false => 'absent',
  }
  file { "debug_${module_name}_vardump":
    ensure  => $debug_vardump_ensure,
    path    => "${settings::vardir}/debug_${module_name}_vardump",
    mode    => '0640',
    owner   => 'root',
    group   => 'root',
    # do not forget to update the class documentation (-> 'debug' parameter) if
    # you change the .reject regex pattern
    content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.sort.map { |k,v| "#{k}: #{v.inspect}"}.join("\n") + "\n" %>'),
  }

}

