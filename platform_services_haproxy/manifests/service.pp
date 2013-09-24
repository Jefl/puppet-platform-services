define platform_services_haproxy::service(
  $ipaddress,
  $ports,
  $options = {},
  $virtual_router_id = undef
) {
  if $::platform_services_haproxy::server::high_available {
    if ! $virtual_router_id {
        fail("virtual_router_id must be defined if high available")
    } else {
      keepalived::instance{$virtual_router_id:
        interface    => 'eth0',
        virtual_ips  => [ "$ipaddress/24" ],
        state        => 'MASTER',
        priority     => 1,
        track_script => [ "haproxy" ],
        auth_type    => "PASS",
        auth_pass    => "635178udDK1AQ123",
      }
    }
  }
  
  # TODO: move this somewhere else...
  case $::mpc_bu {
  'srf': {
    network_config { "eth0:$name":
      ensure    => 'present',
      method    => 'static',
      ipaddress => $ipaddress,
      netmask   => '255.255.252.0',
      onboot    => 'true',
    }~>
    exec {"reload interface eth0:$name":
      command => "/sbin/ifdown eth0:$name;/sbin/ifup eth0:$name",
      refreshonly => true,
    }->
    haproxy::listen{$name:
      ipaddress => $ipaddress,
      ports     => $ports,
      options   => $options,
    }
  }
  default: {
    haproxy::listen{$name:
      ipaddress => $ipaddress,
      ports     => $ports,
      options   => $options,
    }
  }

  platform_services_dns::member::zone{"${name}.${::mpc_zone}.${::mpc_project}.${::mpc_bu}.mpc":
    domain    => "${::mpc_zone}.${::mpc_project}.${::mpc_bu}.mpc",
    hostname  => $name,
    ipaddress => $ipaddress,
  }
}
