# metricbeat
#
# This class installs the Elastic metricbeat statistic and metric
# collector and manages the configuration on the include nodes.
#
# @summary Install, configures and manages Metricbeat on the target node.
#
# @example
#   include metricbeat
#
# Parameters
# ----------
#
# * `ensure`
# [String] Ensures that all required resources are managed or removed
# from the target node. This is good for bulk uninstallation across a
# network. Valid values are 'present' or 'absent'. (default: 'present')
#
# * `manage_repo`
# [Boolean] Weather the upstream (elastic) repository should be
# configured. (default: true)
#
# * `package_ensure`
# [String] The desired state of Package['metricbeat']. Only valid when
# $ensure is present. (default: 'present')
#
# * `path_conf`
# [Absolute Path] The location of the configuration files. Recommend
# leaving the default value. (default: '/etc/metricbeat')
class metricbeat(
  Enum['present', 'absent'] $ensure = 'present',
  Boolean $manage_repo              = true,
  String $package_ensure            = 'present',
  Stdlib::Absolutepath $path_conf   = '/etc/metricbeat',
) {
  if $manage_repo {
    class{'metricbeat::repo':}

    Anchor['metricbeat::begin']
    -> Class['metricbeat::repo']
    -> Class['metricbeat::install']
  }

  if $ensure == 'present' {
    Anchor['metricbeat::begin']
    -> Class['metricbeat::install']
    -> Class['metricbeat::config']
  }
  else {
    Anchor['metricbeat::begin']
    -> Class['metricbeat::install']
  }

  anchor{'metricbeat::begin':}
  class{'metricbeat::config':}
  class{'metricbeat::install':}
}
