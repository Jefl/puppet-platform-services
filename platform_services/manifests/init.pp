class platform_services {
  $vip_mappings = {
    'puppet' => {
      '01' => '13',
    },
    'dns' => {
      '01' => '14',
      '02' => '15',
    },
    'monitor' => {
      '02' => '16',
    },
    'log' => {
      '01' => '17',
    }
    'patch' => {
      '01' => '18',
    },
  }
  $node_role = regsubst($::hostname, '^(\w+)-.*$', '\1')
  $node_nr = regsubst($::hostname, '^.*-(\d+)$', '\1')
  $vips = $vip_mappings[$node_role]

  ::platform_services::validate_var{[
    'lsbmajdistrelease',
    'puppetmaster',
    'mpc_zone',
    'mpc_project',
    'mpc_bu',
    'mpc_network_front',
  ]:}
}
