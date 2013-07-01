ip_segment_map = {
  'srf' => {
    'dev' => '3',
    'test' => '2',
    'prod' => '1',
  },
  'rts' => {
    'dev' => '6',
    'test' => '5',
    'prod' => '4',
  },
  'rsi' => {
    'dev' => '9',
    'test' => '8',
    'prod' => '7',
  },
}

Facter.add("mpc_network_front") do
  setcode do
    fact = nil
    mpc_bu = Facter.value('mpc_bu')
    mpc_project = Facter.value('mpc_project')
    mpc_zone = Facter.value('mpc_zone')
    
    begin
      network_id = ip_segment_map[Facter.value('mpc_bu')][Facter.value('mpc_project')]
    rescue NoMethodError
      network_id = nil
    end

    if network_id
      case Facter.value('mpc_zone')
      when 'bie'
        fact = "10.101.#{network_id}.0"
      when 'zrh'
        fact = "10.102.#{network_id}.0"
      end
    end

    fact
  end
end