# do configuration of resolv.conf and /etc/hosts for generic *nix machines
# nameservers - array of dns nameservers to configure
# domains - array of domains to search bare hosts for
# resolvconf - path and filename to edit
class dns (
  $nameservers = false,
  $domains     = false,
  $hosts       = false,
  $resolvconf  = '/etc/resolv.conf'
) {

  if $::kernel == 'windows' {
    fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
  }

  file { $resolvconf:
    ensure  => present,
    content => template("${module_name}/resolv_conf.erb")
  }

  # setup host entries in addition to dns
  $_hosts = $hosts ? {
    false   => hiera_hash("${module_name}::hosts",{}),
    default => $hosts
  }
  create_resources(host, $_hosts)
}
