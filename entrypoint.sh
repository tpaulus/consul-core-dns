#!/bin/bash

# Resolve Consul Server SRV
dig_result=`dig SRV "$CONSUL_SRV" +short`
consul_servers=""

IFS=$'\n'
for server in $dig_result; do
    IFS=$' '
    read -ra srv_parts <<< "$server"
    consul_servers="$consul_servers${srv_parts[3]%?} "
done

echo "$consul_servers"

# Update Consul Config File with Consul Server IPs
CONSUL_SERVERS="$consul_servers" consul-template -once -template "/etc/consul/agent_config.tpl:/etc/consul/agent_config.hcl"

# Start Supervisord (to start Consul and CoreDNS)
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
