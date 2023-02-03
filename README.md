# consul-core-dns
CoreDNS Container also running a Consul Agent to serve Consul DNS Requests

## Configuration
This container uses SRV records to identify the Consul server(s) to connect to.
Create the SRV Records with the provider of your choice, noting that weight,
priority, or port number will not be used. Consul MUST be running on the
default port (8500).

You'll also need to create an ACL Token for the Agent, it requires the
following permissions:
```hcl
service_prefix "" {
  policy = "read"
}

node_prefix "" {
  "policy" = "write"
}

agent_prefix "" {
  "policy" = "read"
}

key_prefix "" {
  "policy" = "write"
}

keyring = "read"

query_prefix "" {
  "policy" = "read"
}
```

## Usage
```
docker run \
 -e CONSUL_ENCRYPTION_KEY=<Gossip Encryption Key> \
 -e CONSUL_DATACENTER=<Consul Datacenter> \
 -e CONSUL_SRV=<SRV Record> \
 -e AGENT_ACL_TOKEN=<ACL Token for the Agent> \
 -p 10053:53/tcp \
 -p 10053:53/udp \
 ghcr.io/tpaulus/consul-core-dns:main
```

Will run the container, listening to DNS requests on port `10053` via TCP and UDP.